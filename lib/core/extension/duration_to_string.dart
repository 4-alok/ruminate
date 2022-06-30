extension DurationExtensions on Duration {
  String get formatToString {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return inHours > 0
        ? "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) => (n >= 10) ? "$n" : "0$n";
}
