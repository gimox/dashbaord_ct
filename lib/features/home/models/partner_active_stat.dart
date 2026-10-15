class PartnerActiveStat {
  final String partnerName;
  int maleCount = 0;
  int femaleCount = 0;
  int unclassifiedCount = 0;
  int completedCount = 0;
  Map<String, int> langCounts = {};
  Map<String, Map<String, int>> genderLangCounts = {};

  PartnerActiveStat({
    required this.partnerName,
    this.maleCount = 0,
    this.femaleCount = 0,
    this.unclassifiedCount = 0,
    this.completedCount = 0,
    Map<String, int>? langCounts,
    Map<String, Map<String, int>>? genderLangCounts,
  })  : langCounts = langCounts ?? {},
        genderLangCounts = genderLangCounts ?? {};

  int get total => maleCount + femaleCount + unclassifiedCount;

  double get malePercentage => total > 0 ? (maleCount / total * 100) : 0.0;
  double get femalePercentage => total > 0 ? (femaleCount / total * 100) : 0.0;
  double get unclassifiedPercentage =>
      total > 0 ? (unclassifiedCount / total * 100) : 0.0;
  double get completionPercentage =>
      total > 0 ? (completedCount / total * 100) : 0.0;
}
