import 'package:equatable/equatable.dart';

class UrlEntity extends Equatable {
  final String? sId;
  final String? longUrl;
  final String? urlCode;

  const UrlEntity({
    this.sId,
    this.longUrl,
    this.urlCode,
  });

  @override
  List<Object?> get props => [sId, longUrl, urlCode];
}