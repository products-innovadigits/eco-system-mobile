class RatingItemModel {
  final String title;
  final int rating;
  final String comment;
  final bool isCommentFieldVisible;

  RatingItemModel({
    required this.title,
    this.rating = -1,
    this.comment = '',
    this.isCommentFieldVisible = false,
  });

  RatingItemModel copyWith({
    int? rating,
    String? comment,
    bool? isCommentFieldVisible,
  }) {
    return RatingItemModel(
      title: title,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isCommentFieldVisible: isCommentFieldVisible ?? this.isCommentFieldVisible,
    );
  }
}
