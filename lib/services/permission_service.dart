import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {


      if (await Permission.audio.isGranted) return true;

      var audioStatus = await Permission.audio.request();

      if (audioStatus.isGranted) return true;

      if (audioStatus.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      if (await Permission.storage.isGranted) return true;

      var storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    }

    return true;
  }

  Future<bool> hasPermission() async {
    if (Platform.isAndroid) {
      return await Permission.audio.isGranted ||
          await Permission.storage.isGranted;
    }
    return true;
  }
}