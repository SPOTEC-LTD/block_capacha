class VerifyUtil {
  static final int fastClickDelayTime = 1000;
  static int lastClickTime = 0;

  /// 两次点击间隔不能少于1000ms,防止连续点击
  static bool isFastClock() {
    var flag = true;
    var currentClickTime = DateTime.now().millisecondsSinceEpoch;

    if ((currentClickTime - lastClickTime) >= fastClickDelayTime) {
      flag = false;
    }
    lastClickTime = currentClickTime;
    return flag;
  }
}
