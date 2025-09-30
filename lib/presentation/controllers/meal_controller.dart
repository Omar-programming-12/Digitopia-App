import 'package:digitopia_app/core/utils/result.dart';
import 'package:flutter/material.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/usecases/get_meals_usecase.dart';
import '../../domain/usecases/meal_usecases.dart';
import '../../services/django_notification_service.dart';

class MealController extends ChangeNotifier {
  final GetMealsUseCase getMealsUseCase;
  final GetNearbyMealsUseCase getNearbyMealsUseCase;
  final SearchMealsUseCase searchMealsUseCase;
  final AddMealUseCase addMealUseCase;
  final UpdateMealUseCase updateMealUseCase;
  final DeleteMealUseCase deleteMealUseCase;

  MealController({
    required this.getMealsUseCase,
    required this.getNearbyMealsUseCase,
    required this.searchMealsUseCase,
    required this.addMealUseCase,
    required this.updateMealUseCase,
    required this.deleteMealUseCase,
  });

  List<MealEntity> _meals = [];
  List<MealEntity> _filteredMeals = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<MealEntity> get meals => _filteredMeals.isEmpty && _searchQuery.isEmpty ? _meals : _filteredMeals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  Future<void> loadMeals() async {
    _setLoading(true);
    _clearError();

    final result = await getMealsUseCase();
    result.fold(
      (failure) => _setError(_getErrorMessage(failure)),
      (meals) {
        _meals = meals;
        _applyFilters();
      },
    );

    _setLoading(false);
  }

  Future<void> loadNearbyMeals(double lat, double lng, [double radius = 5.0]) async {
    _setLoading(true);
    _clearError();

    final result = await getNearbyMealsUseCase(lat, lng, radius);
    result.fold(
      (failure) => _setError(_getErrorMessage(failure)),
      (meals) {
        _meals = meals;
        _applyFilters();
      },
    );

    _setLoading(false);
  }

  Future<void> searchMeals(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _filteredMeals = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    final result = await searchMealsUseCase(query);
    result.fold(
      (failure) => _setError(_getErrorMessage(failure)),
      (meals) => _filteredMeals = meals,
    );

    _setLoading(false);
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredMeals = [];
    notifyListeners();
  }

  void _applyFilters() {
    if (_searchQuery.isNotEmpty) {
      _filteredMeals = _meals.where((meal) =>
        meal.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        meal.location.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  Future<bool> addMeal(MealEntity meal) async {
    _setLoading(true);
    _clearError();

    final result = await addMealUseCase(meal);
    bool success = false;
    
    result.fold(
      (failure) => _setError(_getErrorMessage(failure)),
      (_) {
        success = true;
        // إرسال إشعار Django
        DjangoNotificationService.sendMealNotification(
          userName: meal.userName,
          mealName: meal.name,
          location: meal.location,
          imageUrl: meal.imageUrl,
        );
        loadMeals();
      },
    );

    _setLoading(false);
    return success;
  }

  Future<bool> updateMeal(MealEntity meal) async {
    _setLoading(true);
    _clearError();

    final result = await updateMealUseCase(meal);
    bool success = false;
    
    result.fold(
      (failure) => _setError(_getErrorMessage(failure)),
      (_) {
        success = true;
        loadMeals();
      },
    );

    _setLoading(false);
    return success;
  }

  Future<bool> deleteMeal(String id) async {
    _setLoading(true);
    _clearError();

    final result = await deleteMealUseCase(id);
    bool success = false;
    
    result.fold(
      (failure) => _setError(_getErrorMessage(failure)),
      (_) {
        success = true;
        loadMeals();
      },
    );

    _setLoading(false);
    return success;
  }

  String _getErrorMessage(AppFailure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'حدث خطأ غير متوقع';
  }
}