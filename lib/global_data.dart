class GlobalData {
  static String? selectedRiskName;
  static String? loggedInUserName;
  static String? oTPNumber;

  static void setRiskName(String riskName) {
    selectedRiskName = riskName;
  }

  static String? getRiskName() {
    return selectedRiskName;
  }

  static void setLoggedInUserName(String userName) {
    loggedInUserName = userName;
  }

  static String? getLoggedInUserName() {
    return loggedInUserName;
  }

  static void setOTPNumber(String oTP) {
    oTPNumber = oTP;
  }

  static String? getOTPNumber() {
    return oTPNumber;
  }

  static void clearUserData() {
    selectedRiskName = null;
    loggedInUserName = null;
    oTPNumber = null;
  }
}
