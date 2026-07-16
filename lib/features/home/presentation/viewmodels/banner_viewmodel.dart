import 'package:flutter/material.dart';
import '../../data/models/banner_model.dart';
import '../../domain/repositories/banner_repository.dart';
import '../../data/repositories/banner_repository_impl.dart';

class BannerViewModel with ChangeNotifier {
  final BannerRepository _repository;

  List<BannerModel> _banners = [];
  bool _isLoading = false;

  BannerViewModel({BannerRepository? repository})
      : _repository = repository ?? BannerRepositoryImpl();

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;

  Future<void> fetchBanners() async {
    _isLoading = true;
    notifyListeners();
    try {
      _banners = await _repository.fetchBanners();
    } catch (e) {
      // rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
