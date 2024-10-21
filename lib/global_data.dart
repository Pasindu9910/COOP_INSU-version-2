class GlobalData {
  static String? selectedRiskName;
  static String? loggedInUserName;

  // Set the selected risk name
  static void setRiskName(String riskName) {
    selectedRiskName = riskName;
  }

  // Get the selected risk name
  static String? getRiskName() {
    return selectedRiskName;
  }

  // Set the logged-in username
  static void setLoggedInUserName(String userName) {
    loggedInUserName = userName;
  }

  // Get the logged-in username
  static String? getLoggedInUserName() {
    return loggedInUserName;
  }

  // Clear user data (logout)
  static void clearUserData() {
    selectedRiskName = null; // Clear selected risk name
    loggedInUserName = null; // Clear logged-in username
  }
}
