import 'package:get_it/get_it.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/viewmodels/login_view_model.dart';
import '../../features/auth/viewmodels/signup_view_model.dart';
import '../../features/home/viewmodels/home_view_model.dart';
import '../../features/dictionary/viewmodels/dictionary_view_model.dart';
import '../../features/dictionary/viewmodels/dictionary_detail_view_model.dart';
import '../../features/settings/viewmodels/settings_view_model.dart';
import '../../features/learn/viewmodels/learn_viewmodel.dart';
import '../repositories/abstract/grammar_repository.dart';
import '../repositories/implementations/grammar_repository_impl.dart';
import '../../features/grammar/viewmodels/grammar_list_view_model.dart';
import '../../features/grammar/viewmodels/category_detail_view_model.dart';
import '../../features/grammar/viewmodels/lesson_detail_view_model.dart';
import '../models/word_model.dart';
import '../repositories/abstract/auth_repository.dart';
import '../repositories/implementations/auth_repository_impl.dart';
import '../repositories/abstract/word_repository.dart';
import '../repositories/implementations/word_repository_impl.dart';
import '../services/audio/audio_service.dart';
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

  // Register audio service as singleton
  locator.registerLazySingleton<AudioService>(() => AudioService());

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

  locator.registerLazySingleton<GrammarRepository>(
    () => GrammarRepositoryImpl(apiClient: locator<BrainyApiClient>()),
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

  locator.registerFactory(
    () => SignupViewModel(authRepository: locator<AuthRepository>()),
  );

  locator.registerFactory(
    () => HomeViewModel(
      wordRepository: locator<WordRepository>(),
      audioService: locator<AudioService>(),
    ),
  );

  locator.registerFactory(
    () => DictionaryViewModel(wordRepository: locator<WordRepository>()),
  );

  locator.registerFactoryParam<DictionaryDetailViewModel, Word, void>(
    (word, _) => DictionaryDetailViewModel(
      wordRepository: locator<WordRepository>(),
      audioService: locator<AudioService>(),
      word: word,
    ),
  );

  locator.registerFactory(
    () => SettingsViewModel(),
  );

  // Grammar view models
  locator.registerFactory(
    () => GrammarListViewModel(grammarRepository: locator<GrammarRepository>()),
  );

  locator.registerFactory(
    () => CategoryDetailViewModel(
        grammarRepository: locator<GrammarRepository>()),
  );

  locator.registerFactory(
    () => LessonDetailViewModel(),
  );

  // Learn view model
  locator.registerFactory(
    () => LearnViewModel(
      wordRepository: locator<WordRepository>(),
      audioService: locator<AudioService>(),
    ),
  );
}
