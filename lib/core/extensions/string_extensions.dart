/// String extension metodları
extension StringExtensions on String {
  /// İlk harfi büyük yapar
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Her kelimenin ilk harfini büyük yapar
  String titleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// String'in geçerli bir email olup olmadığını kontrol eder
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// String'in boş veya sadece boşluk karakterlerinden oluşup oluşmadığını kontrol eder
  bool get isBlank => trim().isEmpty;

  /// Sayısal değere çevirir (hata durumunda null döner)
  int? get toIntOrNull {
    return int.tryParse(this);
  }

  /// Double değere çevirir (hata durumunda null döner)
  double? get toDoubleOrNull {
    return double.tryParse(this);
  }

  /// String'i kısaltır ve sonuna ... ekler
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
}
