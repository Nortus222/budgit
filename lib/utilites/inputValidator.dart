// ignore_for_file: file_names

String? validateDecimal(String? input) {
  if (input == null) return "Input cannot be null";

  double? value = double.tryParse(input);
  if (value == null) return "Input must be a valid number";

  if (input.contains(".")) {
    int afterDecimal = int.parse(input.substring(input.indexOf(".") + 1));
    if (afterDecimal > 100) return "Input must be 2 decimal places at most";
  }

  if (value > 100000) return "Input cannot be more then \$100,000";

  return null;
}
