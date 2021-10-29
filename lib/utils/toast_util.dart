import 'package:flutter_block_captcha/utils/object_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../color_manager.dart';

class ToastUtil {
  static void showToast(String text, {Toast? duration, ToastGravity? gravity}) {
    Fluttertoast.showToast(
        msg: text,
        backgroundColor: ColorManager.textLight,
        gravity: ObjectUtils.isEmpty(gravity) ? ToastGravity?.CENTER : gravity,
        toastLength:
            ObjectUtils.isEmpty(duration) ? Toast?.LENGTH_LONG : duration);
  }
}
