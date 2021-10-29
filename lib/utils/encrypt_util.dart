import 'package:steel_crypt/steel_crypt.dart';

class EncryptUtil {
  /// aes加密
  /// [key]AesCrypt加密key
  /// [content] 需要加密的内容字符串
  static String aesEncode({required String key, required String content}) {
    var aesEncrypter = AesCrypt(key: key, padding: PaddingAES.pkcs7);
    return aesEncrypter.cbc.encrypt(inp: content, iv: '');
  }

  /// aes解密
  /// [key]aes解密key
  /// [content] 需要加密的内容字符串
  static String aesDecode({required String key, required String content}) {
    var aesEncrypter = AesCrypt(key: key, padding: PaddingAES.pkcs7);
    return aesEncrypter.cbc.decrypt(enc: content, iv: '');
  }
}
