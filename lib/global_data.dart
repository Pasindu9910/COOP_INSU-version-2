class GlobalData {
  static String? selectedRiskName;

  static void setRiskName(String riskName) {
    selectedRiskName = riskName;
  }

  static String? getRiskName() {
    return selectedRiskName;
  }
}
