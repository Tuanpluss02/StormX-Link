import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:link/core/usecases/usecase.dart';
import 'package:link/features/url_shortener/domain/entities/shortened_url.dart';
import 'package:link/features/url_shortener/domain/usecases/delete_url.dart';
import 'package:link/features/url_shortener/domain/usecases/get_urls.dart';
import 'package:link/features/url_shortener/domain/usecases/shorten_url.dart';

@injectable
class UrlProvider extends ChangeNotifier {
  final ShortenUrl _shortenUrl;
  final GetUrls _getUrls;
  final DeleteUrl _deleteUrl;

  UrlProvider({
    required ShortenUrl shortenUrl,
    required GetUrls getUrls,
    required DeleteUrl deleteUrl,
  })  : _shortenUrl = shortenUrl,
        _getUrls = getUrls,
        _deleteUrl = deleteUrl;

  List<ShortenedUrl> _urls = [];
  List<ShortenedUrl> get urls => _urls;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> loadUrls() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getUrls(NoParams());

    if (_disposed) return;

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (urls) {
        _urls = urls;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> shorten(String originalUrl) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _shortenUrl(ShortenUrlParams(originalUrl: originalUrl));

    if (_disposed) return;

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (newUrl) {
        _urls.add(newUrl);
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> delete(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _deleteUrl(DeleteUrlParams(id: id));

    if (_disposed) return;

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (_) {
        _urls.removeWhere((url) => url.id == id);
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
