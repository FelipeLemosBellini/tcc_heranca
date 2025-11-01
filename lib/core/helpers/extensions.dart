extension StringExtensions on String {
  String addressAbbreviated() {
    if (length <= 8) return this;
    return '${substring(0, 4)}...${substring(length - 4)}';
  }

  String formatCpf() {
    if (length != 11) return this;
    return '${substring(0, 3)}.${substring(3, 6)}.${substring(6, 9)}-${substring(9, 11)}';
  }
}
