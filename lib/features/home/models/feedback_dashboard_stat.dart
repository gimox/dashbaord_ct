class FeedbackLangStat {
  final String lang;
  int count;
  double sumScores;
  int totalRatingsCount;
  int hq1Count;
  int hq1Sum;
  int hq2Count;
  int hq2Sum;
  int hq3Count;
  int hq3Sum;
  int hq4Count;
  int hq4Sum;
  int textCount;

  FeedbackLangStat({
    required this.lang,
    this.count = 0,
    this.sumScores = 0.0,
    this.totalRatingsCount = 0,
    this.hq1Count = 0,
    this.hq1Sum = 0,
    this.hq2Count = 0,
    this.hq2Sum = 0,
    this.hq3Count = 0,
    this.hq3Sum = 0,
    this.hq4Count = 0,
    this.hq4Sum = 0,
    this.textCount = 0,
  });

  double get averageScore => totalRatingsCount > 0 ? (sumScores / totalRatingsCount) : 0.0;
  double get avgHq1 => hq1Count > 0 ? (hq1Sum / hq1Count) : 0.0;
  double get avgHq2 => hq2Count > 0 ? (hq2Sum / hq2Count) : 0.0;
  double get avgHq3 => hq3Count > 0 ? (hq3Sum / hq3Count) : 0.0;
  double get avgHq4 => hq4Count > 0 ? (hq4Sum / hq4Count) : 0.0;

  void addFeedback({
    int? hq1,
    int? hq2,
    int? hq3,
    int? hq4,
    bool hasText = false,
  }) {
    count++;
    if (hasText) textCount++;

    if (hq1 != null && hq1 > 0) {
      hq1Count++;
      hq1Sum += hq1;
      sumScores += hq1;
      totalRatingsCount++;
    }
    if (hq2 != null && hq2 > 0) {
      hq2Count++;
      hq2Sum += hq2;
      sumScores += hq2;
      totalRatingsCount++;
    }
    if (hq3 != null && hq3 > 0) {
      hq3Count++;
      hq3Sum += hq3;
      sumScores += hq3;
      totalRatingsCount++;
    }
    if (hq4 != null && hq4 > 0) {
      hq4Count++;
      hq4Sum += hq4;
      sumScores += hq4;
      totalRatingsCount++;
    }
  }
}

class CourseFeedbackStat {
  final int courseId;
  final String courseName;
  final String courseShortname;
  int totalFeedbackCount;
  double sumScores;
  int totalRatingsCount;
  final Map<String, FeedbackLangStat> langStats;

  CourseFeedbackStat({
    required this.courseId,
    required this.courseName,
    required this.courseShortname,
    this.totalFeedbackCount = 0,
    this.sumScores = 0.0,
    this.totalRatingsCount = 0,
    Map<String, FeedbackLangStat>? langStats,
  }) : langStats = langStats ?? {};

  double get overallAverage => totalRatingsCount > 0 ? (sumScores / totalRatingsCount) : 0.0;

  List<String> get sortedLanguages {
    final list = langStats.keys.toList();
    list.sort((a, b) => (langStats[b]?.count ?? 0).compareTo(langStats[a]?.count ?? 0));
    return list;
  }

  void addFeedback({
    required String lang,
    int? hq1,
    int? hq2,
    int? hq3,
    int? hq4,
    bool hasText = false,
  }) {
    totalFeedbackCount++;
    final lKey = lang.trim().toUpperCase().isEmpty ? 'N.D.' : lang.trim().toUpperCase();
    final lStat = langStats.putIfAbsent(lKey, () => FeedbackLangStat(lang: lKey));
    lStat.addFeedback(hq1: hq1, hq2: hq2, hq3: hq3, hq4: hq4, hasText: hasText);

    if (hq1 != null && hq1 > 0) {
      sumScores += hq1;
      totalRatingsCount++;
    }
    if (hq2 != null && hq2 > 0) {
      sumScores += hq2;
      totalRatingsCount++;
    }
    if (hq3 != null && hq3 > 0) {
      sumScores += hq3;
      totalRatingsCount++;
    }
    if (hq4 != null && hq4 > 0) {
      sumScores += hq4;
      totalRatingsCount++;
    }
  }
}
