


class RupiahFormat{
  static String? formatRupiah(int? amount) {
      String? formattedAmount = amount.toString();
      // Add thousand separators
      for (int i = formattedAmount.length - 3; i > 0; i -= 3) {
        formattedAmount = formattedAmount!.substring(0, i) +
            '.' +
            formattedAmount.substring(i, formattedAmount.length);
      }
      return formattedAmount;
    }

     static String formatAsRupiah(String value) {
      String numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
      String formattedValue = numericValue;
      for (int i = formattedValue.length - 3; i > 0; i -= 3) {
        formattedValue =
            '${formattedValue.substring(0, i)}.${formattedValue.substring(i, formattedValue.length)}';
      }
      return formattedValue;
    }
}