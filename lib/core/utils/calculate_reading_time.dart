int calculateReadingTime(String content) {
  final contentLength = content.split(RegExp(r"\s+")).length;
  final time = (contentLength / 200).ceil();
  return time;
}
