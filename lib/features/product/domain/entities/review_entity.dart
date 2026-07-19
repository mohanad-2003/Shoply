import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  const ReviewEntity({
    required this.author,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });

  final String author;
  final double rating;
  final String comment;
  final String timeAgo;

  @override
  List<Object?> get props => [author, rating, comment, timeAgo];
}
