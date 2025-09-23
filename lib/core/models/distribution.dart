class Distribution {
  String requestBy;
  String status;
  String testatorId;
  String cpf;
  DistributionPlan distributionPlan;

  Distribution({
    required this.requestBy,
    required this.status,
    required this.testatorId,
    required this.cpf,
    required this.distributionPlan,
  });
}

class DistributionPlan {
  List<Transactions> transactions;

  DistributionPlan({required this.transactions});
}

class Transactions {
  final To to;
  final Asset asset;

  Transactions({required this.to, required this.asset});
}

class To {
  String address;
  String name;

  To({required this.address, required this.name});
}

class Asset {
  String tokenAddress;
  String symbol;
  String name;
  String balance;

  Asset({
    required this.tokenAddress,
    required this.symbol,
    required this.name,
    required this.balance,
  });
}
