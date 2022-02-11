extension StringOperations on String {
  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  bool isValidPasswordLength(int passLength) {
    return length >= passLength ? true : false;
  }

  bool isStringIdentical(String otherString) {
    return this == otherString;
  }

  bool isValidPassword() {
    return RegExp("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}\$").hasMatch(this);
  }
}
