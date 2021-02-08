class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  // Exception handler
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
