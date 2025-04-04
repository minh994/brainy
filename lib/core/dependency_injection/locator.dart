import 'package:get_it/get_it.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/viewmodels/login_view_model.dart';
import '../../features/vocabulary/viewmodels/vocabulary_list_view_model.dart';
import '../repositories/abstract/auth_repository.dart';
import '../repositories/implementations/auth_repository_impl.dart';
import '../services/http/brainy_api_client.dart';
import '../services/storage/storage_service.dart';
import '../services/storage/shared_prefs_storage.dart';

// Global service locator
final GetIt locator = GetIt.instance;

/// Sets up the dependency injection container
Future<void> setupLocator() async {
  // Services - Storage
  // Initialize SharedPrefsStorage
  final sharedPrefsStorage = SharedPrefsStorage();
  await sharedPrefsStorage.init();

  // Register storage service
  locator.registerSingleton<StorageService>(sharedPrefsStorage);

  // API Client
  locator.registerSingleton<BrainyApiClient>(
    BrainyApiClient(
      baseUrl:
          'http://localhost/brainy_php/index.php/api', // Replace with actual API URL
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

  // Controllers
  locator.registerFactory<AuthController>(
    () => AuthController(
      authRepository: locator<AuthRepository>(),
    ),
  );

  // View models
  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(authRepository: locator<AuthRepository>()),
  );

  locator.registerFactory<VocabularyListViewModel>(
    () => VocabularyListViewModel(),
  );
}
