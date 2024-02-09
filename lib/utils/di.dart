/* file: di.dart */
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:twilio_video_calls/utils/di.config.dart'; //This will automatically generated after: flutter pub run build_runner build

final serviceLocator = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
void initGetIt() {
  init(serviceLocator);
}
