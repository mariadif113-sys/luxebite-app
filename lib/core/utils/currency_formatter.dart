/// Currency formatter for LuxeBite - Algerian Dinar (DZD)
class CurrencyFormatter {
  /// Format a price in Algerian Dinar
  /// e.g., dzd(2500, isAr: true) → "2,500 د.ج"
  static String dzd(double amount, {bool isAr = false}) {
    final formatted = amount.toInt().toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return isAr ? '$formatted د.ج' : '$formatted DZD';
  }

  /// Alias for dzd()
  static String format(double amount, {bool isAr = false}) => dzd(amount, isAr: isAr);

  static String symbol(bool isAr) => isAr ? 'د.ج' : 'DZD';
}
