import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_remote_datasource.dart';
import '../models/meal_model.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;

  MealRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<MealEntity>>> getAllMeals() async {
    try {
      final meals = await remoteDataSource.getAllMeals();
      return Success(meals.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (failure) {
      return Failure(failure);
    } catch (e) {
      return Failure(ServerFailure('خطأ غير متوقع'));
    }
  }

  @override
  Future<Result<MealEntity>> getMealById(String id) async {
    try {
      final meal = await remoteDataSource.getMealById(id);
      return Success(meal.toEntity());
    } on ServerFailure catch (failure) {
      return Failure(failure);
    } catch (e) {
      return Failure(ServerFailure('خطأ غير متوقع'));
    }
  }

  @override
  Future<Result<void>> addMeal(MealEntity meal) async {
    try {
      final mealModel = MealModel(
        id: meal.id,
        name: meal.name,
        quantity: meal.quantity,
        location: meal.location,
        latitude: meal.latitude,
        longitude: meal.longitude,
        imageUrl: meal.imageUrl,
        privacy: meal.privacy,
        userName: meal.userName,
        timestamp: meal.timestamp,
        available: meal.available,
      );
      await remoteDataSource.addMeal(mealModel);
      return const Success(null);
    } on ServerFailure catch (failure) {
      return Failure(failure);
    } catch (e) {
      return Failure(ServerFailure('خطأ غير متوقع'));
    }
  }

  @override
  Future<Result<void>> updateMeal(MealEntity meal) async {
    try {
      final mealModel = MealModel(
        id: meal.id,
        name: meal.name,
        quantity: meal.quantity,
        location: meal.location,
        latitude: meal.latitude,
        longitude: meal.longitude,
        imageUrl: meal.imageUrl,
        privacy: meal.privacy,
        userName: meal.userName,
        timestamp: meal.timestamp,
        available: meal.available,
      );
      await remoteDataSource.updateMeal(mealModel);
      return const Success(null);
    } on ServerFailure catch (failure) {
      return Failure(failure);
    } catch (e) {
      return Failure(ServerFailure('خطأ غير متوقع'));
    }
  }

  @override
  Future<Result<void>> deleteMeal(String id) async {
    try {
      await remoteDataSource.deleteMeal(id);
      return const Success(null);
    } on ServerFailure catch (failure) {
      return Failure(failure);
    } catch (e) {
      return Failure(ServerFailure('خطأ غير متوقع'));
    }
  }

  @override
  Future<Result<List<MealEntity>>> searchMeals(String query) async {
    try {
      final meals = await remoteDataSource.searchMeals(query);
      return Success(meals.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (failure) {
      return Failure(failure);
    } catch (e) {
      return Failure(ServerFailure('خطأ غير متوقع'));
    }
  }

  @override
  Future<Result<List<MealEntity>>> getNearbyMeals(double lat, double lng, double radius) async {
    try {
      final meals = await remoteDataSource.getNearbyMeals(lat, lng, radius);
      return Success(meals.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (failure) {
      return Failure(failure);
    } catch (e) {
      return Failure(ServerFailure('خطأ غير متوقع'));
    }
  }
}