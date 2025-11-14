extension BigintExtensions on BigInt {
  String weiToEth({int precision = 5}) {
    const int decimals = 18; // ETH tem 18 casas

    final bool neg = isNegative;
    final BigInt absWei = abs();

    final BigInt base = BigInt.from(10).pow(decimals); // 10^18
    BigInt intPart = absWei ~/ base; // parte inteira
    final BigInt remainder = absWei % base; // resto em wei

    // Arredondamento half-up para 5 casas
    final BigInt scaleDown = BigInt.from(
      10,
    ).pow(decimals - precision); // 10^(18-5) = 10^13
    final BigInt half = scaleDown ~/ BigInt.from(2); // para arredondar
    BigInt frac = (remainder + half) ~/ scaleDown; // 5 casas

    // Se arredondar para 100000, carrega 1 na parte inteira
    final BigInt limit = BigInt.from(10).pow(precision);
    if (frac == limit) {
      intPart += BigInt.one;
      frac = BigInt.zero;
    }

    final String fracStr = frac.toString().padLeft(precision, '0');
    final String sign = neg ? '-' : '';
    return '$sign$intPart.$fracStr';
  }
}
