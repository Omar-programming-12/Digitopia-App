import '../../core/utils/result.dart';
import '../entities/meal_entity.dart';
import '../repositories/meal_repository.dart';

class GetMealsUseCase {
  final MealRepository repository;

  GetMealsUseCase(this.repository);

  Future<Result<List<MealEntity>>> call() => repository.getAllMeals();
}

class GetNearbyMealsUseCase {
  final MealRepository repository;

  GetNearbyMealsUseCase(this.repository);

  Future<Result<List<MealEntity>>> call(double lat, double lng, [double radius = 5.0]) =>
      repository.getNearbyMeals(lat, lng, radius);
}

class SearchMealsUseCase {
  final MealRepository repository;

  SearchMealsUseCase(this.repository);

  Future<Result<List<MealEntity>>> call(String query) => repository.searchMeals(query);
}