import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../network/api_service.dart';
import '../services/storage_service.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/auth/cubit/signup_cubit.dart';
import '../../features/auth/cubit/login_cubit.dart';
import '../../features/home/services/categories_service.dart';
import '../../features/home/services/products_service.dart';
import '../../features/home/cubit/categories_cubit.dart';
import '../../features/home/cubit/category_products_cubit.dart';
import '../../features/home/cubit/product_details_cubit.dart';
import '../../features/home/cubit/products_cubit.dart';
import '../../features/home/cubit/offers_cubit.dart';
import '../../features/home/cubit/search_cubit.dart';
import '../../features/cart/cubit/cart_cubit.dart';
import '../../features/checkout/cubit/order_cubit.dart';
import '../../features/favorites/cubit/favorites_cubit.dart';
import '../../features/reviews/cubit/review_cubit.dart';
import '../../features/settings/services/settings_service.dart';
import '../../features/settings/cubit/update_profile_cubit.dart';
import '../../features/settings/cubit/contact_us_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Storage Service
  sl.registerLazySingleton(() => StorageService(sl<SharedPreferences>()));

  // Dio Client
  sl.registerLazySingleton(() => DioClient());

  // API Service
  sl.registerLazySingleton(() => ApiService(sl<DioClient>()));

  // Auth Service
  sl.registerLazySingleton(() => AuthService(sl<ApiService>()));

  // Categories Service
  sl.registerLazySingleton(() => CategoriesService(sl<ApiService>()));

  // Products Service
  sl.registerLazySingleton(() => ProductsService(sl<ApiService>()));

  // Settings Service
  sl.registerLazySingleton(() => SettingsService(sl<ApiService>()));

  // Auth Cubits
  sl.registerFactory(() => SignupCubit(sl<AuthService>()));
  sl.registerFactory(
    () => LoginCubit(sl<AuthService>(), sl<StorageService>(), sl<DioClient>()),
  );

  // Categories Cubits
  sl.registerFactory(() => CategoriesCubit(sl<CategoriesService>()));
  sl.registerFactory(() => CategoryProductsCubit(sl<CategoriesService>()));

  // Products Cubits
  sl.registerFactory(() => ProductDetailsCubit(sl<ProductsService>()));
  sl.registerFactory(() => ProductsCubit(sl<ProductsService>()));
  sl.registerFactory(() => OffersCubit(sl<ProductsService>()));
  sl.registerFactory(() => SearchCubit(sl<ProductsService>()));

  // Cart Cubit
  sl.registerFactory(() => CartCubit(sl<ProductsService>()));

  // Order Cubit
  sl.registerFactory(() => OrderCubit(sl<ProductsService>()));

  // Favorites Cubit
  sl.registerFactory(() => FavoritesCubit(sl<ProductsService>()));

  // Review Cubit
  sl.registerFactory(() => ReviewCubit(sl<ProductsService>()));

  // Settings Cubits
  sl.registerFactory(() => UpdateProfileCubit(sl<AuthService>()));
  sl.registerFactory(() => ContactUsCubit(sl<SettingsService>()));
}
