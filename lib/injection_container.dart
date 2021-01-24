import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:ika/amplifyconfiguration.dart';
import 'package:ika/core/network/network_info.dart';
import 'package:ika/data/datasources/auth_local_data_source.dart';
import 'package:ika/data/datasources/auth_remote_data_source.dart';
import 'package:ika/data/repositories/authentication_repository_impl.dart';
import 'package:ika/domain/repositories/authentication_repository.dart';
import 'package:ika/domain/usecases/authentication.dart';
import 'package:ika/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:ika/presentation/blocs/authentication/authentication_event.dart';
import 'package:ika/presentation/blocs/login/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

var gi = GetIt.instance;

Future<void> init() async {
  //Amplify
  Amplify amplify = Amplify();
  AmplifyAuthCognito auth = AmplifyAuthCognito();
  amplify.addPlugin(authPlugins: [auth]);
  await amplify.configure(amplifyconfig);

  //BLoC
  gi.registerFactory<LoginBloc>(() => LoginBloc(
      authenticationBloc: gi<AuthenticationBloc>(),
      authentication: gi<Authentication>()));
  gi.registerLazySingleton<AuthenticationBloc>(() =>
      AuthenticationBloc(authentication: gi<Authentication>())
        ..add(AppLoaded()));

  //UseCase
  gi.registerLazySingleton<Authentication>(
      () => Authentication(gi<AuthenticationRepository>()));

  //Repository
  gi.registerLazySingleton<AuthenticationRepository>(() =>
      AuthenticationRepositoryImpl(
          remoteDataSource: gi<AuthRemoteDataSource>(),
          localDataSource: gi<AuthLocalDataSource>(),
          networkInfo: gi<NetworkInfo>()));

  //Data Source
  gi.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(authCategory: Amplify.Auth));
  gi.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(
      sharedPreferences: gi<SharedPreferences>(), authCategory: Amplify.Auth));

  //Core
  gi.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(gi<DataConnectionChecker>()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  gi.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  gi.registerLazySingleton<DataConnectionChecker>(
      () => DataConnectionChecker());
}
