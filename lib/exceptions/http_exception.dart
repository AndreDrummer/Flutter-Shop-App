class HttpException implements Exception {

  String msg;

  HttpException(this.msg);

  @override
  String toString() {
    super.toString();
    return msg;
  }
}