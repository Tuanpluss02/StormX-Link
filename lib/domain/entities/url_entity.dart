import 'package:equatable/equatable.dart';

class UrlEntity extends Equatable {
  final String? id;
  final String? longUrl;
  final String? urlCode;

  const UrlEntity({
    this.id,
    this.longUrl,
    this.urlCode,
  });

  @override
  List<Object?> get props => [id, longUrl, urlCode];
}