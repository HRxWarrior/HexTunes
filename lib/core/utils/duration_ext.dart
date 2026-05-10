extension DurationFormat on Duration {
  String get mmss {
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '\$m:\$s';
  }
  String get hmmss {
    if (inHours < 1) return mmss;
    return '\${inHours}:\${inMinutes.remainder(60).toString().padLeft(2,'0')}:\${inSeconds.remainder(60).toString().padLeft(2,'0')}';
  }
}
