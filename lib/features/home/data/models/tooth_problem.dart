class ToothProblem {
  final int toothNumber; // FDI number (11–48)
  final String disease;

  ToothProblem({required this.toothNumber, required this.disease});

  factory ToothProblem.fromLabel(String label) {
    // Example labels:
    // 1_6_Caries
    // 2_5_Deep Caries

    final parts = label.split('_');

    final quadrant = int.parse(parts[0]);
    final tooth = int.parse(parts[1]);
    final disease = parts.sublist(2).join(' ');

    final fdiNumber = quadrant * 10 + tooth;

    return ToothProblem(toothNumber: fdiNumber, disease: disease);
  }
}
