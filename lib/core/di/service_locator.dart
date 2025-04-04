import 'package:get_it/get_it.dart';

import '../repositories/abstract/auth_repository.dart';
import '../repositories/abstract/word_repository.dart';
import '../repositories/implementations/auth_repository_impl.dart';
import '../repositories/implementations/word_repository_impl.dart';
import '../services/http/brainy_api_client.dart';
import '../services/storage/shared_prefs_storage.dart';
import '../services/storage/storage_service.dart';
import '../../features/auth/controllers/auth_controller.dart';

final GetIt serviceLocator = GetIt.instance;

class ServiceLocator {
  static Future<void> setup() async {
    // Services
    final sharedPrefsStorage = SharedPrefsStorage();
    await sharedPrefsStorage.init();

    serviceLocator.registerSingleton<StorageService>(sharedPrefsStorage);

    serviceLocator.registerSingleton<BrainyApiClient>(
      BrainyApiClient(
        baseUrl:
            'http://localhost/brainy_php/index.php/api', // Replace with actual API URL
        storageService: serviceLocator<StorageService>(),
      ),
    );

    // Repositories
    serviceLocator.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(
        apiClient: serviceLocator<BrainyApiClient>(),
        storageService: serviceLocator<StorageService>(),
      ),
    );

    serviceLocator.registerSingleton<WordRepository>(
      WordRepositoryImpl(
        apiClient: serviceLocator<BrainyApiClient>(),
      ),
    );

    // Controllers
    serviceLocator.registerFactory<AuthController>(
      () => AuthController(
        authRepository: serviceLocator<AuthRepository>(),
      ),
    );
  }
}
