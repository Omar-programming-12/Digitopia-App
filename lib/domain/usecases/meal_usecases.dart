import '../../core/utils/result.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository.dart';

class AddMealUseCase {
  final MealRepository repository;

  AddMealUseCase(this.repository);

  Future<Result<void>> call(MealEntity meal) => repository.addMeal(meal);
}

class UpdateMealUseCase {
  final MealRepository repository;

  UpdateMealUseCase(this.repository);

  Future<Result<void>> call(MealEntity meal) => repository.updateMeal(meal);
}

class DeleteMealUseCase {
  final MealRepository repository;

  DeleteMealUseCase(this.repository);

  Future<Result<void>> call(String id) => repository.deleteMeal(id);
}