class GlobalData {
  static String? selectedRiskName;
  static String? loggedInUserName;


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

  
  static void clearUserData() {
    selectedRiskName = null; 
    loggedInUserName = null; 
  }
}
