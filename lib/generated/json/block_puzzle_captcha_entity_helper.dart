import 'package:flutter_block_captcha/model/block_puzzle_captcha_entity.dart';

blockPuzzleCaptchaEntityFromJson(
    BlockPuzzleCaptchaEntity data, Map<String, dynamic> json) {
  if (json['getBlockPuzzleCaptcha'] != null) {
    data.getBlockPuzzleCaptcha =
        BlockPuzzleCaptcha().fromJson(json['getBlockPuzzleCaptcha']);
  }
  return data;
}

Map<String, dynamic> blockPuzzleCaptchaEntityToJson(
    BlockPuzzleCaptchaEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['getBlockPuzzleCaptcha'] = entity.getBlockPuzzleCaptcha?.toJson();
  return data;
}

blockPuzzleCaptchaFromJson(BlockPuzzleCaptcha data, Map<String, dynamic> json) {
  if (json['originalImageBase64'] != null) {
    data.originalImageBase64 = json['originalImageBase64'].toString();
  }
  if (json['jigsawImageBase64'] != null) {
    data.jigsawImageBase64 = json['jigsawImageBase64'].toString();
  }
  if (json['secretKey'] != null) {
    data.secretKey = json['secretKey'].toString();
  }
  if (json['token'] != null) {
    data.token = json['token'].toString();
  }
  return data;
}

Map<String, dynamic> blockPuzzleCaptchaToJson(BlockPuzzleCaptcha entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['originalImageBase64'] = entity.originalImageBase64;
  data['jigsawImageBase64'] = entity.jigsawImageBase64;
  data['secretKey'] = entity.secretKey;
  data['token'] = entity.token;
  return data;
}
