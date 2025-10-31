extension Date on DateTime {
  // add date time now 01/01/0001
}

extension Strings on String {
  //formatação de carteiras

  String addressAbbreviated() {
    if (length <= 8) return this;
    return '${substring(0, 4)}...${substring(length - 4)}';
  }

  String formatCpf() {
    if (length != 11) return this;
    return '${substring(0, 3)}.${substring(3, 6)}.${substring(6, 9)}-${substring(9, 11)}';
  }
}
