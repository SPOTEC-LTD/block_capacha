import 'package:flutter_block_captcha/generated/json/base/json_convert_content.dart';

class CheckBlockPuzzleCaptchaEntity
    with JsonConvert<CheckBlockPuzzleCaptchaEntity> {
  late CheckBlockPuzzleCaptcha checkBlockPuzzleCaptcha;
}

class CheckBlockPuzzleCaptcha with JsonConvert<CheckBlockPuzzleCaptcha> {
  String? captchaType;
  String? token;
  String? pointJson;
}
