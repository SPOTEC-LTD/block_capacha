class CheckBlockPuzzleCaptcha {
  CheckBlockPuzzleCaptcha(
      {this.captchaType = '',
      this.token = '',
      this.pointJson = '',
      this.errorMsg});

  final String? captchaType;
  final String? token;
  final String? pointJson;
  final String? errorMsg;

  @override
  String toString() {
    return 'CheckBlockPuzzleCaptcha{pointJson: $pointJson}';
  }
}
