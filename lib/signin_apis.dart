import 'model/block_puzzle_captcha_entity.dart';
import 'model/check_block_puzzle_captcha_entity.dart';
import 'services/http/http_service.dart';

class SigninAPIs {
  /// 加载人机验证码
  static Future<BlockPuzzleCaptchaEntity> getCaptcha() async {
    return HttpService().get<BlockPuzzleCaptchaEntity>(
      '/captcha/get',
    );
  }

  /// 第一次验证验证码
  static Future<CheckBlockPuzzleCaptchaEntity> checkCaptcha(
      {required String pointJson, required String token}) async {
    return HttpService().post<CheckBlockPuzzleCaptchaEntity>('/captcha/check',
        params: {
          'pointJson': pointJson,
          'token': token,
        },
        contentType: HttpContentType.json);
  }
}
