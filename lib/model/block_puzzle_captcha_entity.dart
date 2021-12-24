class BlockPuzzleCaptchaEntity {
  BlockPuzzleCaptchaEntity({
    this.originalImageBase64 = '',
    this.jigsawImageBase64 = '',
    this.secretKey = '',
    this.token = '',
  });
  final String? originalImageBase64;
  final String? jigsawImageBase64;
  final String? secretKey;
  final String? token;

  @override
  String toString() {
    return 'BlockPuzzleCaptchaEntity{originalImageBase64: $originalImageBase64, jigsawImageBase64: $jigsawImageBase64, secretKey: $secretKey, token: $token}';
  }
}
