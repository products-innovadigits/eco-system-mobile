class RatingItem {
  final String title;
  final int rating;
  final String comment;
  final bool isCommentFieldVisible;

  RatingItem({
    required this.title,
    this.rating = -1,
    this.comment = '',
    this.isCommentFieldVisible = false,
  });

  RatingItem copyWith({
    int? rating,
    String? comment,
    bool? isCommentFieldVisible,
  }) {
    return RatingItem(
      title: title,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isCommentFieldVisible: isCommentFieldVisible ?? this.isCommentFieldVisible,
    );
  }
}
