import 'package:core_system/core/utility/export.dart';

class DocumentCommentsModel extends SingleMapper {
  bool? succeeded;
  CommentsData? data;

  DocumentCommentsModel({this.succeeded, this.data});

  DocumentCommentsModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'] as bool?;
    data = json['data'] != null
        ? CommentsData.fromJson((json['data'] as Map).cast<String, dynamic>())
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['succeeded'] = succeeded;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      DocumentCommentsModel.fromJson(json);
}

class CommentsData {
  int? totalCount;
  List<DocumentComment>? items;

  CommentsData({this.totalCount, this.items});

  CommentsData.fromJson(Map<String, dynamic> json) {
    totalCount = (json['totalCount'] as num?)?.toInt();
    if (json['items'] is List) {
      items = <DocumentComment>[];
      for (var v in (json['items'] as List)) {
        items!.add(
          DocumentComment.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['totalCount'] = totalCount;
    if (items != null) map['items'] = items!.map((e) => e.toJson()).toList();
    return map;
  }
}

class DocumentComment extends SingleMapper {
  int? id;
  int? documentDataId;
  String? text;

  DocumentComment({this.id, this.documentDataId, this.text});

  DocumentComment.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    documentDataId = (json['documentDataId'] as num?)?.toInt();
    text = json['text']?.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['documentDataId'] = documentDataId;
    map['text'] = text;
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) => DocumentComment.fromJson(json);
}
