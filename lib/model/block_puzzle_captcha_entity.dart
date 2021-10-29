import 'package:flutter_block_captcha/generated/json/base/json_convert_content.dart';

class BlockPuzzleCaptchaEntity with JsonConvert<BlockPuzzleCaptchaEntity> {
  late BlockPuzzleCaptcha getBlockPuzzleCaptcha;
}

class BlockPuzzleCaptcha with JsonConvert<BlockPuzzleCaptcha> {
  String? originalImageBase64;
  String? jigsawImageBase64;
  String? secretKey;
  String? token;
}
