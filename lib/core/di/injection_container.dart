import 'package:digitopia_app/data/datasources/meal_remote_datasource.dart';
import 'package:digitopia_app/data/repositories/meal_repository_impl.dart';
import 'package:digitopia_app/domain/repositories/meal_repository.dart';
import 'package:digitopia_app/domain/usecases/get_meals_usecase.dart';
import 'package:digitopia_app/domain/usecases/meal_usecases.dart';
import 'package:digitopia_app/presentation/controllers/meal_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;


final sl = GetIt.instance;

Future<void> init() async {
  // Controllers
  sl.registerFactory(() => MealController(
    getMealsUseCase: sl(),
    getNearbyMealsUseCase: sl(),
    searchMealsUseCase: sl(),
    addMealUseCase: sl(),
    updateMealUseCase: sl(),
    deleteMealUseCase: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetMealsUseCase(sl()));
  sl.registerLazySingleton(() => GetNearbyMealsUseCase(sl()));
  sl.registerLazySingleton(() => SearchMealsUseCase(sl()));
  sl.registerLazySingleton(() => AddMealUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMealUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMealUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}