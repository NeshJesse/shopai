class Feature {
  final String name;
  int votes;
  final int threshold;
  bool hasVoted;

  Feature({
    required this.name,
    this.votes = 0,
    required this.threshold,
    this.hasVoted = false,
  });
}
