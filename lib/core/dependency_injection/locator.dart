import 'package:get_it/get_it.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/viewmodels/login_view_model.dart';
import '../../features/vocabulary/viewmodels/vocabulary_list_view_model.dart';
import '../../features/vocabulary/viewmodels/vocabulary_detail_view_model.dart';
import '../../features/auth/viewmodels/signup_view_model.dart';
import '../repositories/abstract/auth_repository.dart';
import '../repositories/implementations/auth_repository_impl.dart';
import '../repositories/abstract/word_repository.dart';
import '../repositories/implementations/word_repository_impl.dart';
import '../services/http/brainy_api_client.dart';
import '../services/storage/storage_service.dart';
import '../services/storage/shared_prefs_storage.dart';
import '../config/env_config.dart';

// Global service locator
final GetIt locator = GetIt.instance;

/// Sets up the dependency injection container
Future<void> setupLocator() async {
  // Config
  locator.registerSingleton<EnvConfig>(EnvConfig());
  final envConfig = locator<EnvConfig>();

  // Services - Storage
  // Initialize SharedPrefsStorage
  final sharedPrefsStorage = SharedPrefsStorage();
  await sharedPrefsStorage.init();

  // Register storage service
  locator.registerSingleton<StorageService>(sharedPrefsStorage);

  // API Client
  locator.registerSingleton<BrainyApiClient>(
    BrainyApiClient(
      baseUrl: envConfig.apiBaseUrl,
      storageService: locator<StorageService>(),
    ),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiClient: locator<BrainyApiClient>(),
      storageService: locator<StorageService>(),
    ),
  );

  locator.registerLazySingleton<WordRepository>(
    () => WordRepositoryImpl(apiClient: locator<BrainyApiClient>()),
  );

  // Controllers
  locator.registerFactory<AuthController>(
    () => AuthController(
      authRepository: locator<AuthRepository>(),
    ),
  );

  // View models
  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      authRepository: locator<AuthRepository>(),
    ),
  );

  locator.registerFactory<VocabularyListViewModel>(
    () => VocabularyListViewModel(),
  );

  locator.registerFactory(
    () => VocabularyDetailViewModel(wordRepository: locator<WordRepository>()),
  );

  locator.registerFactory(
    () => SignupViewModel(authRepository: locator<AuthRepository>()),
  );
}
