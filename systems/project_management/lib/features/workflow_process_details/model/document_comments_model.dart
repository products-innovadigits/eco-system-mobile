import 'package:core_system/core/utility/export.dart';

class DocumentCommentsModel extends SingleMapper {
  bool? succeeded;
  CommentsData? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  DocumentCommentsModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  DocumentCommentsModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'] as bool?;
    data = json['data'] != null
        ? CommentsData.fromJson((json['data'] as Map).cast<String, dynamic>())
        : null;
    warningErrors = json['warningErrors'];
    if (json['validationErrors'] != null) {
      validationErrors = List<dynamic>.from(json['validationErrors']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['succeeded'] = succeeded;
    if (data != null) map['data'] = data!.toJson();
    map['warningErrors'] = warningErrors;
    if (validationErrors != null) {
      map['validationErrors'] = validationErrors;
    }
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      DocumentCommentsModel.fromJson(json);
}

class CommentsData {
  List<DocumentComment>? items;
  int? currentPage;
  int? pageSize;
  int? totalPages;
  int? nextPage;
  int? previousPage;
  bool? isLastPage;
  int? totalCount;

  CommentsData({
    this.items,
    this.currentPage,
    this.pageSize,
    this.totalPages,
    this.nextPage,
    this.previousPage,
    this.isLastPage,
    this.totalCount,
  });

  CommentsData.fromJson(Map<String, dynamic> json) {
    if (json['items'] is List) {
      items = <DocumentComment>[];
      for (var v in (json['items'] as List)) {
        items!.add(
          DocumentComment.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }
    currentPage = (json['currentPage'] as num?)?.toInt();
    pageSize = (json['pageSize'] as num?)?.toInt();
    totalPages = (json['totalPages'] as num?)?.toInt();
    nextPage = (json['nextPage'] as num?)?.toInt();
    previousPage = (json['previousPage'] as num?)?.toInt();
    isLastPage = json['isLastPage'] as bool?;
    totalCount = (json['totalCount'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (items != null) map['items'] = items!.map((e) => e.toJson()).toList();
    map['currentPage'] = currentPage;
    map['pageSize'] = pageSize;
    map['totalPages'] = totalPages;
    map['nextPage'] = nextPage;
    map['previousPage'] = previousPage;
    map['isLastPage'] = isLastPage;
    map['totalCount'] = totalCount;
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
