# flutter_block_captcha
* flutter插件，用于人机验证交互

A new Flutter package.

## Getting Started

# 使用方式:
````Dart
Future<T?> loadingBlockPuzzle<T>() async {
    final titleTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: -0.3,
      color: ThemeOptions.of(ContextUtil.navigatorContext).textFFFFFF,
    );
    final updateTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: -0.3,
      color: ThemeOptions.of(ContextUtil.navigatorContext).backgroundFF6B00,
    );
    return showDialog<T>(
      context: ContextUtil.navigatorContext,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return BlockPuzzleCaptchaPage<T>(
          loadCaptcha: _loadCaptcha,
          checkCaptchaCallback: _checkCaptcha,
          backGroundColor:
              ThemeOptions.of(ContextUtil.navigatorContext).background303030,
          sliderImageWidget: Image.asset(
            ImageTool.findVariant(R.slider),
            width: 63,
            height: 32,
            // color: Colors.blue,
          ),
          title: S.of(ContextUtil.navigatorContext).captchaTitle,
          successMsg: S.of(ContextUtil.navigatorContext).captchaSuccessMsg,
          titleTextStyle: titleTextStyle,
          updateText: S.of(ContextUtil.navigatorContext).captchaUpdate,
          updateTextStyle: updateTextStyle,
          closeText: S.of(ContextUtil.navigatorContext).captchaClose,
          closeTextStyle: updateTextStyle,
          movedXBorderColor:
              ThemeOptions.of(ContextUtil.navigatorContext).backgroundFFAF75,
          defaultXBorderColor:
              ThemeOptions.of(ContextUtil.navigatorContext).background4A4A4A,
        );
      },
    );
  }
````

# 参数说明：
* [loadCaptcha] 获取人机验证图片-接口操作
* [checkCaptchaCallback] 校验回调-接口操作
* [titleTextStyle] 标题字体样式
* [title] 标题
* [backGroundColor] 弹窗背景色
* [updateText] 刷新
* [closeText] 关闭
* [successMsg] 成功提示信息
* [defaultXBorderColor] 滑块左边颜色，已滑动区域边框颜色
* [defaultXBorderColor] 滑块右边颜色，未滑动边框颜色
* [sliderImageWidget] 滑块的图片widget