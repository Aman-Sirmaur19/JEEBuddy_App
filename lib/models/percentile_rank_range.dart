class PercentileRankRange {
  final double pMin;
  final double pMax;
  final int rMin;
  final int rMax;

  PercentileRankRange(this.pMin, this.pMax, this.rMin, this.rMax);

  bool containsPercentile(double p) => p <= pMax && p >= pMin;

  bool containsRank(int r) => r >= rMin && r <= rMax;

  int getRank(double p) {
    final t = (pMax - p) / (pMax - pMin);
    return (rMin + t * (rMax - rMin)).round();
  }

  double getPercentile(int r) {
    final t = (r - rMin) / (rMax - rMin);
    return double.parse((pMax - t * (pMax - pMin)).toStringAsFixed(6));
  }
}

final List<PercentileRankRange> rankData = [
  PercentileRankRange(99.99989145, 100.0, 1, 20),
  PercentileRankRange(99.994681, 99.997394, 24, 80),
  PercentileRankRange(99.990990, 99.994029, 55, 83),
  PercentileRankRange(99.977205, 99.988819, 85, 210),
  PercentileRankRange(99.960163, 99.975034, 215, 367),
  PercentileRankRange(99.934980, 99.956364, 375, 599),
  PercentileRankRange(99.901113, 99.928901, 610, 911),
  PercentileRankRange(99.851616, 99.893732, 920, 1367),
  PercentileRankRange(99.795063, 99.845212, 1375, 1888),
  PercentileRankRange(99.710831, 99.782472, 1900, 2664),
  PercentileRankRange(99.597399, 99.688579, 2700, 3710),
  PercentileRankRange(99.456939, 99.573193, 3800, 5003),
  PercentileRankRange(99.272084, 99.431214, 5100, 6706),
  PercentileRankRange(99.028614, 99.239737, 6800, 8949),
  PercentileRankRange(98.732389, 98.990296, 9000, 11678),
  PercentileRankRange(98.317414, 98.666935, 11800, 15501),
  PercentileRankRange(97.811260, 98.254132, 15700, 20164),
  PercentileRankRange(97.142937, 97.685672, 20500, 26321),
  PercentileRankRange(96.204550, 96.978272, 26500, 34966),
  PercentileRankRange(94.998594, 96.064850, 35000, 46076),
  PercentileRankRange(93.471231, 94.749479, 46500, 60147),
  PercentileRankRange(91.072128, 93.152971, 61000, 82249),
  PercentileRankRange(87.512225, 90.702200, 83000, 115045),
  PercentileRankRange(82.016062, 86.907944, 117000, 165679),
  PercentileRankRange(73.287808, 80.982153, 166000, 246089),
  PercentileRankRange(58.151490, 71.302052, 264383, 385534),

  // Extended ranges to reach 0 percentile
  PercentileRankRange(45.000000, 57.999999, 385535, 500000),
  PercentileRankRange(32.000000, 44.999999, 500001, 620000),
  PercentileRankRange(20.000000, 31.999999, 620001, 750000),
  PercentileRankRange(10.000000, 19.999999, 750001, 870000),
  PercentileRankRange(5.000000, 9.999999, 870001, 940000),
  PercentileRankRange(1.000000, 4.999999, 940001, 990000),
  PercentileRankRange(0.000000, 0.999999, 990001, 1050000),
];

// Convert Percentile to Rank
int? percentileToRank(double p) {
  for (var range in rankData) {
    if (range.containsPercentile(p)) {
      return range.getRank(p);
    }
  }
  return null;
}

// Convert Rank to Percentile
double? rankToPercentile(int r) {
  for (var range in rankData) {
    if (range.containsRank(r)) {
      return range.getPercentile(r);
    }
  }
  return null;
}
