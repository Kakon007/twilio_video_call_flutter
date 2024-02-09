import 'package:permission_handler/permission_handler.dart';

class PermissionRequest{


  static void requestBluetoothConnect() async{
    PermissionStatus status = await Permission.bluetoothConnect.status;

    if (status != PermissionStatus.granted) {
      status = await Permission.bluetoothConnect.request();
    }

    if (status == PermissionStatus.granted) {
      ///code if permission not granted
    } else {
      /// code if permission is granted
    }
  }
}