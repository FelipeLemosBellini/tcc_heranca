class HeirModel {
  final String address;
  final int percentage;

  HeirModel({required this.address, required this.percentage});

  // Converte o objeto para Map (pra salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'percentage': percentage,
    };
  }

  // Cria um objeto a partir do Map (pra ler do Firestore)
  factory HeirModel.fromMap(Map<String, dynamic> map) {
    return HeirModel(
      address: map['address'],
      percentage: map['percentage'],
    );
  }
}
