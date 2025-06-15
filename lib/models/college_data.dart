class CollegeData {
  final String round;
  final String institute;
  final String program;
  final String quota;
  final String seatType;
  final String gender;
  final int openingRank;
  final int closingRank;

  CollegeData({
    required this.round,
    required this.institute,
    required this.program,
    required this.quota,
    required this.seatType,
    required this.gender,
    required this.openingRank,
    required this.closingRank,
  });

  factory CollegeData.fromCsvRow(List<dynamic> row) {
    return CollegeData(
      round: row[0].toString(),
      institute: row[1].toString(),
      program: row[2].toString(),
      quota: row[3].toString(),
      seatType: row[4].toString(),
      gender: row[5].toString(),
      openingRank: int.tryParse(row[6].toString()) ?? 0,
      closingRank: int.tryParse(row[7].toString()) ?? 0,
    );
  }
}
