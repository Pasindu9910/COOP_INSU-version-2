class GlobalData {
  static String? selectedRiskName;
  static String? loggedInUserName;
  static String? vehicleNumber;

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

  static void setVehicleNumber(String number) {
    vehicleNumber = number;
  }

  static String? getVehicleNumber(String text) {
    return vehicleNumber;
  }

  static void clearUserData() {
    selectedRiskName = null;
    loggedInUserName = null;
    vehicleNumber = null;
  }
}
