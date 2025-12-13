import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:link/features/url_shortener/domain/entities/shortened_url.dart';

part 'shortened_url_model.freezed.dart';
part 'shortened_url_model.g.dart';

@freezed
class ShortenedUrlModel with _$ShortenedUrlModel {
  const ShortenedUrlModel._();

  const factory ShortenedUrlModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'original_url') required String originalUrl,
    @JsonKey(name: 'short_url') required String shortUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'click_count', defaultValue: 0) required int clickCount,
  }) = _ShortenedUrlModel;

  factory ShortenedUrlModel.fromJson(Map<String, dynamic> json) =>
      _$ShortenedUrlModelFromJson(json);

  ShortenedUrl toEntity() {
    return ShortenedUrl(
      id: id,
      originalUrl: originalUrl,
      shortUrl: shortUrl,
      createdAt: createdAt,
      clickCount: clickCount,
    );
  }
}
