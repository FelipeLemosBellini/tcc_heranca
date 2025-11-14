extension BigIntExtensions on BigInt {
  String weiToEth({
    int precision = 18,         // quantas casas você quer exibir (0..18)
    bool trimTrailingZeros = true,
  }) {
    const int decimals = 18; // ETH tem 18 casas
    // garante 0 <= precision <= 18
    if (precision < 0) precision = 0;
    if (precision > decimals) precision = decimals;

    final bool neg = isNegative;
    final BigInt absWei = abs();

    final BigInt base = BigInt.from(10).pow(decimals); // 10^18
    BigInt intPart = absWei ~/ base;                    // parte inteira
    final BigInt remainder = absWei % base;             // resto em wei

    final BigInt scaleDown = BigInt.from(10).pow(decimals - precision); // 10^(18-precision)
    final BigInt half = scaleDown ~/ BigInt.from(2);                     // half-up
    BigInt frac = precision == 0 ? BigInt.zero : (remainder + half) ~/ scaleDown;

    // Carry: se arredondou para 10^precision (ex.: 1.999995 -> 2.00000)
    final BigInt limit = BigInt.from(10).pow(precision);
    if (precision > 0 && frac == limit) {
      intPart += BigInt.one;
      frac = BigInt.zero;
    }
    // Se precision==0, ainda pode haver carry para parte inteira:
    if (precision == 0 && (remainder + half) >= base) {
      intPart += BigInt.one;
    }

    final String sign = neg ? '-' : '';
    if (precision == 0) {
      return '$sign$intPart';
    }

    // Monta fração com padding, depois remove zeros à direita
    String fracStr = frac.toString().padLeft(precision, '0');
    if (trimTrailingZeros) {
      fracStr = fracStr.replaceFirst(RegExp(r'0+$'), '');
    }

    // Se não sobrou fração, não mostra ponto
    if (fracStr.isEmpty) return '$sign$intPart';
    return '$sign$intPart.$fracStr';
  }
}