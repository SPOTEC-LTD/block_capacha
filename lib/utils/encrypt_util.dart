import 'package:encrypt/encrypt.dart';

class EncryptUtil {
  /// aes加密 第三方库encrypt
  /// [keyString] AesCrypt加密key
  /// [content] 需要加密的内容字符串
  static String aesEncode(
      {required String keyString, required String content}) {
    final key = Key.fromUtf8(keyString);
    final Encrypter encrypter = Encrypter(AES(key, mode: AESMode.ecb));

    return encrypter.encrypt(content, iv: IV.fromLength(16)).base64;
  }
}
