import 'package:get_it/get_it.dart';

import '../features/car/data/source/car_data_source.dart';
import '../features/car/domain/car_bloc/car_bloc.dart';
import '../features/onboarding/domain/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

void initializeDependencies() {
  getIt.registerSingleton<CarDataSource>(CarDataSource());
  getIt.registerLazySingleton(() => CarBloc());
  getIt.registerSingleton<AuthBloc>(AuthBloc());
}
