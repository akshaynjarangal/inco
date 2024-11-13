String? validateEmail(String? value) {
  // Regular expression for basic email validation
  String pattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regExp = RegExp(pattern);

  if (value == null || value.isEmpty) {
    return 'Please enter an email';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}
