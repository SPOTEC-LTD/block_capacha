import 'package:flutter_block_captcha/model/check_block_puzzle_captcha_entity.dart';

checkBlockPuzzleCaptchaEntityFromJson(
    CheckBlockPuzzleCaptchaEntity data, Map<String, dynamic> json) {
  if (json['checkBlockPuzzleCaptcha'] != null) {
    data.checkBlockPuzzleCaptcha =
        CheckBlockPuzzleCaptcha().fromJson(json['checkBlockPuzzleCaptcha']);
  }
  return data;
}

Map<String, dynamic> checkBlockPuzzleCaptchaEntityToJson(
    CheckBlockPuzzleCaptchaEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['checkBlockPuzzleCaptcha'] = entity.checkBlockPuzzleCaptcha?.toJson();
  return data;
}

checkBlockPuzzleCaptchaFromJson(
    CheckBlockPuzzleCaptcha data, Map<String, dynamic> json) {
  if (json['captchaType'] != null) {
    data.captchaType = json['captchaType'].toString();
  }
  if (json['token'] != null) {
    data.token = json['token'].toString();
  }
  if (json['pointJson'] != null) {
    data.pointJson = json['pointJson'].toString();
  }
  return data;
}

Map<String, dynamic> checkBlockPuzzleCaptchaToJson(
    CheckBlockPuzzleCaptcha entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['captchaType'] = entity.captchaType;
  data['token'] = entity.token;
  data['pointJson'] = entity.pointJson;
  return data;
}
