import 'package:get_it/get_it.dart';
import 'repositories/lead_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/lead_viewmodel.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<LeadRepository>(() => LeadRepository());
  locator.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
  locator.registerLazySingleton<LeadViewModel>(
    () => LeadViewModel(leadRepository: locator<LeadRepository>()),
  );
}
