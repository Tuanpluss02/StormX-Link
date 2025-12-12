import 'package:equatable/equatable.dart';

class ShortenedUrl extends Equatable {
  final String id;
  final String originalUrl;
  final String shortUrl;
  final DateTime createdAt;
  final int clickCount;

  const ShortenedUrl({
    required this.id,
    required this.originalUrl,
    required this.shortUrl,
    required this.createdAt,
    this.clickCount = 0,
  });

  @override
  List<Object?> get props => [id, originalUrl, shortUrl, createdAt, clickCount];
}
