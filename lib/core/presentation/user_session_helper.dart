import 'dart:developer';

import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_local_storage.dart';
import 'package:get_it/get_it.dart';

class UserSessionHelper {
  static Future<String?> getUserId() async {
    return await GetIt.I<AuthLocalStorage>().getUserId();
  }
}
