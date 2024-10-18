class GlobalData {
  static String? selectedRiskName;
  static String? loggedInUserName;

  static void setRiskName(String riskName) {
    selectedRiskName = riskName;
  }

  static String? getRiskName() {
    return selectedRiskName;
  }

  // Add this method to set the username
  static void setLoggedInUserName(String userName) {
    loggedInUserName = userName;
  }

  // Add this method to get the username
  static String? getLoggedInUserName() {
    return loggedInUserName;
  }
}
