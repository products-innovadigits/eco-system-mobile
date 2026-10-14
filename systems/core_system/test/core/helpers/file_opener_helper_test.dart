import 'dart:io';

import 'package:core_system/core/helpers/file_opener_helper.dart';
import 'package:core_system/core/helpers/launcher_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String tempPath;

  _FakePathProvider(this.tempPath);

  @override
  Future<String?> getTemporaryPath() async => tempPath;
}

void main() {
  group('cache naming', () {
    const url =
        'https://194.163.168.5:448/FileServer/Project/ProjectStepComment/1791890765 - test.xlsx';

    test('keeps the decoded file name', () {
      expect(FileOpenerHelper.cacheFileName(url), '1791890765 - test.xlsx');
    });

    test('replaces characters a file name cannot hold', () {
      expect(
        FileOpenerHelper.cacheFileName('https://x/a%3Fb%3A.pdf'),
        'a_b_.pdf',
      );
      expect(FileOpenerHelper.cacheFileName('https://x/'), 'file');
    });

    test('hashes the same URL the same way, different URLs differently', () {
      expect(FileOpenerHelper.urlHash(url), FileOpenerHelper.urlHash(url));
      expect(FileOpenerHelper.urlHash(url), hasLength(8));
      expect(
        FileOpenerHelper.urlHash('https://a/report.pdf'),
        isNot(FileOpenerHelper.urlHash('https://b/report.pdf')),
      );
    });
  });

  test('resolves server-relative paths like LauncherHelper did', () {
    expect(
      LauncherHelper.resolveFileUrl('/Reports/1.pdf'),
      'https://194.163.168.5:448/Reports/1.pdf',
    );
    const absolute = 'https://194.163.168.5:448/FileServer/a.pdf';
    expect(LauncherHelper.resolveFileUrl(absolute), absolute);
  });

  group('download', () {
    late Directory temp;
    late HttpServer server;
    late int requests;
    late bool failNext;

    setUp(() async {
      temp = await Directory.systemTemp.createTemp('file_opener_test');
      PathProviderPlatform.instance = _FakePathProvider(temp.path);

      requests = 0;
      failNext = false;
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) {
        requests++;
        if (failNext) {
          request.response.statusCode = 500;
        } else {
          // The content changes with every request, like a regenerated report.
          request.response.add([1, 2, 3, requests]);
        }
        request.response.close();
      });
    });

    tearDown(() async {
      await server.close(force: true);
      await temp.delete(recursive: true);
    });

    String fileUrl(String name) =>
        'http://${server.address.host}:${server.port}/files/$name';

    test('reuses an earlier download when asked to', () async {
      final url = fileUrl('1791890025%20-%20photo.jpg');

      final first = await FileOpenerHelper.download(url, reuseDownloaded: true);
      expect(first.path, endsWith('/1791890025 - photo.jpg'));
      expect(await first.readAsBytes(), [1, 2, 3, 1]);

      final second = await FileOpenerHelper.download(
        url,
        reuseDownloaded: true,
      );
      expect(second.path, first.path);
      expect(requests, 1, reason: 'the cached copy is reused');
    });

    test('fetches fresh content by default', () async {
      final url = fileUrl('report.pdf');

      await FileOpenerHelper.download(url);
      final second = await FileOpenerHelper.download(url);

      expect(requests, 2);
      expect(await second.readAsBytes(), [1, 2, 3, 2]);
    });

    test('keeps same-named files from different URLs apart', () async {
      final a = await FileOpenerHelper.download(fileUrl('a/report.pdf'));
      final b = await FileOpenerHelper.download(fileUrl('b/report.pdf'));
      expect(a.path, isNot(b.path));
      expect(requests, 2);
    });

    test('leaves nothing behind when the download fails', () async {
      failNext = true;
      final url = fileUrl('broken.pdf');

      await expectLater(FileOpenerHelper.download(url), throwsA(anything));
      final leftovers = temp
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.contains('broken.pdf'));
      expect(leftovers, isEmpty);

      // A later attempt downloads again instead of reusing a broken file.
      failNext = false;
      final file = await FileOpenerHelper.download(url);
      expect(await file.readAsBytes(), hasLength(4));
    });
  });
}
