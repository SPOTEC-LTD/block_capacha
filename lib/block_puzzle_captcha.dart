import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_block_captcha/utils/object_utils.dart';

import 'color_manager.dart';
import 'model/block_puzzle_captcha_entity.dart';
import 'model/check_block_puzzle_captcha_entity.dart';
import 'utils/encrypt_util.dart';
import 'utils/verify_util.dart';
import 'utils/widget_util.dart';

typedef LoadCaptchaCallback = Future<Object?> Function();
typedef CheckCaptchaCallback = Future<Object?> Function(
    String pointJson, String token);

class BlockPuzzleCaptchaPage<T> extends StatefulWidget {
  BlockPuzzleCaptchaPage({
    required this.loadCaptcha,
    required this.checkCaptchaCallback,
    required this.title,
    required this.updateText,
    required this.closeText,
    required this.successMsg,
    required this.movedXBorderColor,
    required this.sliderImageWidget,
    this.backGroundColor,
    this.titleTextStyle,
    this.updateTextStyle,
    this.closeTextStyle,
    this.defaultXBorderColor,
  });

  /// [loadCaptcha] 获取人机验证图片-接口操作
  final LoadCaptchaCallback loadCaptcha;

  /// [checkCaptchaCallback] 校验回调-接口操作
  final CheckCaptchaCallback checkCaptchaCallback;

  /// [titleTextStyle] 标题字体样式
  final TextStyle? titleTextStyle;

  /// [title] 标题
  final String title;

  /// [backGroundColor] 弹窗背景色
  final Color? backGroundColor;

  /// [updateText] 刷新
  final String updateText;
  final TextStyle? updateTextStyle;

  /// [closeText] 关闭
  final String closeText;
  final TextStyle? closeTextStyle;

  /// [successMsg] 成功提示信息
  final String successMsg;

  /// 滑块左边颜色，已滑动区域边框颜色
  final Color movedXBorderColor;

  /// 滑块右边颜色，未滑动边框颜色
  final Color? defaultXBorderColor;

  /// 滑块的图片
  final Widget sliderImageWidget;
  @override
  _BlockPuzzleCaptchaPageState createState() =>
      _BlockPuzzleCaptchaPageState<T>();
}

class _BlockPuzzleCaptchaPageState<T> extends State<BlockPuzzleCaptchaPage<T>>
    with TickerProviderStateMixin {
  String baseImageBase64 = '';
  String slideImageBase64 = '';
  String captchaToken = '';
  String secretKey = ''; //加密key
  String errorMsg = ''; // 错误信息

  Size baseSize = Size.zero; //底部基类图片
  Size slideSize = Size.zero; //滑块图片

  var movedXBorderColor; //滑块拖动时，左边已滑的区域边框颜色
  double sliderStartX = 0; //滑块未拖前的X坐标
  double sliderXMoved = 0;
  bool sliderMoveFinish = false; //滑块拖动结束
  bool checkResultAfterDrag = false; //拖动后的校验结果

  //-------------动画------------
  bool _showTimeLine = false; //是否显示动画部件
  bool _checkSuccess = false; //校验是否成功
  AnimationController? controller;

  //高度动画
  Animation<double>? offsetAnimation;

  //底部部件key
  final GlobalKey _containerKey = GlobalKey();

  //背景图key
  final GlobalKey _baseImageKey = GlobalKey();

  //滑块
  final GlobalKey _slideImageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _loadCaptcha();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaxScaleTextWidget(
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var dialogWidth = mediaQuery.size.width;
    if (dialogWidth < 340) {
      dialogWidth = mediaQuery.size.width - 8;
    } else {
      dialogWidth = 340;
    }
    // 设计要求固定大小，不按百分比
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          key: _containerKey,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: widget.backGroundColor ?? Colors.white,
          ),
          width: 340,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 顶部文字提示
              _topContainer(),
              // 中间图片部分
              _middleContainer(),
              // 滑块
              _bottomContainer(),
              // 底部按钮
              _bottomButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 顶部，提示
  Widget _topContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 14, 10, 12),
      alignment: Alignment.topLeft,
      child: Text(
        widget.title,
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: widget.titleTextStyle ??
            TextStyle(
                fontSize: 14,
                color: ColorManager.textDark,
                fontWeight: FontWeight.w500),
      ),
    );
  }

  /// 中间部分
  Widget _middleContainer() {
    ////显示验证码
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Stack(
        children: <Widget>[
          ///底图 310*155
          baseImageBase64.isNotEmpty
              ? Image.memory(
                  Base64Decoder().convert(baseImageBase64),
                  // fit: BoxFit.fitWidth,
                  width: 310,
                  height: 155,
                  key: _baseImageKey,
                  gaplessPlayback: true,
                )
              : Container(
                  width: 310,
                  height: 155,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),

          ///滑块图
          slideImageBase64.isNotEmpty
              ? Container(
                  margin: EdgeInsets.fromLTRB(sliderXMoved, 0, 0, 0),
                  child: Image.memory(
                    Base64Decoder().convert(slideImageBase64),
                    width: 68.2,
                    height: 155,
                    key: _slideImageKey,
                    gaplessPlayback: true,
                  ),
                )
              : Container(height: 155),

          Positioned(
              bottom: 0,
              left: -10,
              right: -10,
              child: Offstage(
                offstage: !_showTimeLine,
                child: FractionalTranslation(
                  translation: Offset(0, offsetAnimation!.value),
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    color: _checkSuccess
                        ? ColorManager.kLineUpColor.withOpacity(0.4)
                        : ColorManager.kLineDownColor.withOpacity(0.4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _checkSuccess ? widget.successMsg : errorMsg,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: ColorManager.textWhite),
                    ),
                  ),
                ),
              )),
          Positioned(
              bottom: -20,
              left: 0,
              right: 0,
              child: Offstage(
                offstage: !_showTimeLine,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 20,
                  color: Colors.white,
                ),
              ))
        ],
      ),
    );
  }

  /// 底部，滑动区域
  Widget _bottomContainer() {
    return baseSize.width > 0
        ? Container(
            height: 32,
            width: 310,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: <Widget>[
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    color: widget.defaultXBorderColor,
                  ),
                ),
                Container(
                  width: sliderXMoved + 3,
                  height: 14,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.5),
                          bottomLeft: Radius.circular(7.5)),
                      color: movedXBorderColor),
                ),
                GestureDetector(
                  onPanStart: (startDetails) {
                    ///开始
                    sliderStartX = startDetails.localPosition.dx;
                  },
                  onPanUpdate: (updateDetails) {
                    ///更新
                    var _w1 = _baseImageKey.currentContext!.size!.width -
                        _slideImageKey.currentContext!.size!.width;
                    var offset = updateDetails.localPosition.dx - sliderStartX;
                    if (offset < 0) {
                      offset = 0;
                    }
                    if (offset > _w1) {
                      offset = _w1;
                    }
                    setState(() {
                      sliderXMoved = offset;
                    });
                    //滑动过程，改变滑块左边框颜色
                    _updateSliderColorIcon();
                  },
                  onPanEnd: (endDetails) {
                    //结束
                    _checkCaptcha(sliderXMoved * 70 / 31, captchaToken);
                  },
                  child: Container(
                    width: 63,
                    height: 32,
                    margin: EdgeInsets.only(
                        left: sliderXMoved > 0 ? sliderXMoved : 1),
                    child: widget.sliderImageWidget,
                  ),
                )
              ],
            ))
        : Container();
  }

  /// 底部 button
  Widget _bottomButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 11,
      ),
      child: Row(
        children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              if (VerifyUtil.isFastClock()) {
                return;
              }
              _loadCaptcha();
            },
            child: Text(
              widget.updateText,
              style: widget.updateTextStyle ??
                  TextStyle(fontSize: 14, color: ColorManager.textBlue),
            ),
          ),
          SizedBox(width: 35),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              widget.closeText,
              style: widget.closeTextStyle ??
                  TextStyle(fontSize: 14, color: ColorManager.textBlue),
            ),
          ),
          SizedBox(width: 30),
        ],
      ),
    );
  }

  /// 初始化动画
  void _initAnimation() {
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    offsetAnimation = Tween<double>(begin: 0.5, end: 0)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.ease))
      ..addListener(() {
        setState(() {});
      });
  }

  /// 反向执行动画
  Future _reverseAnimation() async {
    await controller!.reverse();
  }

  /// 正向执行动画
  void _forwardAnimation() async {
    await controller!.forward();
  }

  /// 校验通过
  void checkSuccess(String content) {
    setState(() {
      checkResultAfterDrag = true;
      _checkSuccess = true;
      _showTimeLine = true;
    });
    _forwardAnimation();
    _updateSliderColorIcon();
    // widget.onSuccess(content);
    //刷新验证码
    Future.delayed(Duration(milliseconds: 1000)).then((v) {
      _reverseAnimation().then((v) {
        setState(() {
          _showTimeLine = false;
        });
        Navigator.pop(context, content);
      });
    });
  }

  /// 校验失败
  void checkFail() {
    setState(() {
      _showTimeLine = true;
      _checkSuccess = false;
      checkResultAfterDrag = false;
    });
    _forwardAnimation();
    _updateSliderColorIcon();

    //刷新验证码
    Future.delayed(Duration(milliseconds: 1000)).then((v) {
      _reverseAnimation().then((v) {
        setState(() {
          _showTimeLine = false;
        });
        _loadCaptcha();
        //回调
        // if (widget.onFail != null) {
        //   widget.onFail();
        // }
      });
    });
  }

  /// 重设滑动颜色与图标
  void _updateSliderColorIcon() {
    var _movedXBorderColor; //滑块拖动时，左边已滑的区域边框颜色

    //滑块的背景色
    if (sliderMoveFinish) {
      //拖动结束
      _movedXBorderColor = checkResultAfterDrag ? Colors.green : Colors.red;
    } else {
      //拖动未开始或正在拖动中
      _movedXBorderColor = widget.movedXBorderColor;
    }
    movedXBorderColor = _movedXBorderColor;
    setState(() {});
  }

  /// 刷新状态 加载验证码
  void _loadCaptcha() async {
    setState(() {
      _showTimeLine = false;
      sliderMoveFinish = false;
      checkResultAfterDrag = false;
      movedXBorderColor = widget.movedXBorderColor; //滑块拖动时，左边已滑的区域边框颜色
      baseImageBase64 = '';
      slideImageBase64 = '';
    });
    Object? value = await widget.loadCaptcha();
    if (value == null) {
      setState(() {
        secretKey = '';
      });
      return;
    }
    value = value as BlockPuzzleCaptchaEntity;
    if (value.secretKey == null || value.secretKey!.isEmpty) {
      setState(() {
        secretKey = '';
      });
      return;
    }
    sliderXMoved = 0;
    sliderStartX = 0;
    captchaToken = '';
    checkResultAfterDrag = false;

    secretKey = value.secretKey ?? '';
    baseImageBase64 = value.originalImageBase64!;
    baseImageBase64 = baseImageBase64.replaceAll('\n', '');
    slideImageBase64 = value.jigsawImageBase64!;
    slideImageBase64 = slideImageBase64.replaceAll('\n', '');
    captchaToken = value.token!;

    var baseR = await WidgetUtil.getImageWH(
        image: Image.memory(Base64Decoder().convert(baseImageBase64)));
    baseSize = baseR.size;

    var silderR = await WidgetUtil.getImageWH(
        image: Image.memory(Base64Decoder().convert(slideImageBase64)));
    slideSize = silderR.size;

    setState(() {});
  }

  /// 校验验证码
  void _checkCaptcha(sliderXMoved, captchaToken) async {
    setState(() {
      sliderMoveFinish = true;
    });

    // pointJson参数需要aes加密
    var pointMap = {'x': sliderXMoved, 'y': 5};
    var pointStr = json.encode(pointMap);
    var cryptedStr = pointStr;

    // secretKey 不为空 进行as加密
    if (!ObjectUtils.isEmpty(secretKey)) {
      cryptedStr =
          EncryptUtil.aesEncode(keyString: secretKey, content: pointStr);
    }
    Object? value = await widget.checkCaptchaCallback(cryptedStr, captchaToken);
    if (null == value) {
      checkFail();
      return;
    }
    value = value as CheckBlockPuzzleCaptcha;
    if (null == value.pointJson || value.pointJson!.isEmpty) {
      errorMsg = value.errorMsg ?? '';
      checkFail();
      return;
    }
    // 如果不加密  将  token  和 坐标序列化 通过  --- 链接成字符串
    var captchaVerification = '$captchaToken---$pointStr';
    if (!ObjectUtils.isEmpty(secretKey)) {
      // 如果加密  将  token  和 坐标序列化 通过  --- 链接成字符串 进行加密  加密密钥为 _clickWordCaptchaModel.secretKey
      captchaVerification = EncryptUtil.aesEncode(
          keyString: secretKey, content: captchaVerification);
    }
    print('====captchaVerification=$captchaVerification===');
    checkSuccess(captchaVerification);
    // SigninAPIs.checkCaptcha(
    //   pointJson: cryptedStr,
    //   token: captchaToken,
    // ).then((value) {
    //   if (ObjectUtils.isEmpty(value)) {
    //     checkFail();
    //     return;
    //   }
    //   if (!ObjectUtils.isEmpty(value)) {
    //     // 如果不加密  将  token  和 坐标序列化 通过  --- 链接成字符串
    //     var captchaVerification = '$captchaToken---$pointStr';
    //     if (!ObjectUtils.isEmpty(secretKey)) {
    //       // 如果加密  将  token  和 坐标序列化 通过  --- 链接成字符串 进行加密  加密密钥为 _clickWordCaptchaModel.secretKey
    //       captchaVerification = EncryptUtil.aesEncode(
    //           key: secretKey, content: captchaVerification);
    //     }
    //     checkSuccess(captchaVerification);
    //   } else {
    //     checkFail();
    //   }
    // }).catchError((error) {
    //   if (!ObjectUtils.isEmpty(error.message)) {
    //     errorMsg = error.message;
    //   }
    //   checkFail();
    // });
  }
}

class MaxScaleTextWidget extends StatelessWidget {
  final double max;
  final Widget child;

  MaxScaleTextWidget({Key? key, this.max = 1.0, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var textScaleFactor = min(max, data.textScaleFactor);
    return MediaQuery(
        data: data.copyWith(textScaleFactor: textScaleFactor), child: child);
  }
}
