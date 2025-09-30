import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../models/meal_model.dart';


abstract class MealRemoteDataSource {
  Future<List<MealModel>> getAllMeals();
  Future<MealModel> getMealById(String id);
  Future<void> addMeal(MealModel meal);
  Future<void> updateMeal(MealModel meal);
  Future<void> deleteMeal(String id);
  Future<List<MealModel>> searchMeals(String query);
  Future<List<MealModel>> getNearbyMeals(double lat, double lng, double radius);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final http.Client client;

  MealRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MealModel>> getAllMeals() async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}/meals'),
        headers: AppConstants.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw ServerFailure('فشل في جلب الوجبات');
      }
    } catch (e) {
      throw ServerFailure('خطأ في الاتصال بالخادم');
    }
  }

  @override
  Future<MealModel> getMealById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}/meals/$id'),
        headers: AppConstants.headers,
      );

      if (response.statusCode == 200) {
        return MealModel.fromJson(json.decode(response.body));
      } else {
        throw ServerFailure('الوجبة غير موجودة');
      }
    } catch (e) {
      throw ServerFailure('خطأ في جلب الوجبة');
    }
  }

  @override
  Future<void> addMeal(MealModel meal) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}/meals'),
        headers: AppConstants.headers,
        body: json.encode(meal.toJson()),
      );

      if (response.statusCode != 201) {
        throw ServerFailure('فشل في إضافة الوجبة');
      }
    } catch (e) {
      throw ServerFailure('خطأ في إضافة الوجبة');
    }
  }

  @override
  Future<void> updateMeal(MealModel meal) async {
    try {
      final response = await client.put(
        Uri.parse('${AppConstants.baseUrl}/meals/${meal.id}'),
        headers: AppConstants.headers,
        body: json.encode(meal.toJson()),
      );

      if (response.statusCode != 200) {
        throw ServerFailure('فشل في تحديث الوجبة');
      }
    } catch (e) {
      throw ServerFailure('خطأ في تحديث الوجبة');
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('${AppConstants.baseUrl}/meals/$id'),
        headers: AppConstants.headers,
      );

      if (response.statusCode != 200) {
        throw ServerFailure('فشل في حذف الوجبة');
      }
    } catch (e) {
      throw ServerFailure('خطأ في حذف الوجبة');
    }
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}/meals/search?q=$query'),
        headers: AppConstants.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw ServerFailure('فشل في البحث');
      }
    } catch (e) {
      throw ServerFailure('خطأ في البحث');
    }
  }

  @override
  Future<List<MealModel>> getNearbyMeals(double lat, double lng, double radius) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}/meals/nearby?lat=$lat&lng=$lng&radius=$radius'),
        headers: AppConstants.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw ServerFailure('فشل في جلب الوجبات القريبة');
      }
    } catch (e) {
      throw ServerFailure('خطأ في جلب الوجبات القريبة');
    }
  }
}