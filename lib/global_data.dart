class GlobalData {
  static String? selectedRiskName;
  static String? loggedInUserName;
  static String? oTPNumber;
  static String? nICnumber;

  static void setRiskName(String riskName) {
    selectedRiskName = riskName;
  }

  static String? getRiskName() {
    return selectedRiskName;
  }

  static void setnICnumber(String nic) {
    nICnumber = nic;
  }

  static String? getnICnumber() {
    return nICnumber;
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
    nICnumber = null;
  }
}
