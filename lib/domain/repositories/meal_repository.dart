import '../../core/utils/result.dart';
import '../entities/meal_entity.dart';

abstract class MealRepository {
  Future<Result<List<MealEntity>>> getAllMeals();
  Future<Result<MealEntity>> getMealById(String id);
  Future<Result<void>> addMeal(MealEntity meal);
  Future<Result<void>> updateMeal(MealEntity meal);
  Future<Result<void>> deleteMeal(String id);
  Future<Result<List<MealEntity>>> searchMeals(String query);
  Future<Result<List<MealEntity>>> getNearbyMeals(double lat, double lng, double radius);
}