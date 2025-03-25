import 'package:flutter/material.dart';

class TestadorView extends StatelessWidget {
  const TestadorView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> testamentos = [
      {
        "titulo": "Testamento de João",
        "data": "12/03/2025",
        "endereco": "0x1234...ABCD",
        "valor": "3.5 ETH"
      },
      {
        "titulo": "Testamento de Maria",
        "data": "05/06/2024",
        "endereco": "0x5678...EFGH",
        "valor": "1.2 ETH"
      },
      {
        "titulo": "Testamento de Carlos",
        "data": "20/09/2023",
        "endereco": "0x9ABC...XYZ1",
        "valor": "5.0 ETH"
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Testamentos Criados'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: testamentos.length,
          itemBuilder: (context, index) {
            final testamento = testamentos[index];

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testamento["titulo"]!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Criado em: ${testamento["data"]}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const Divider(),

                    const Text(
                      "Endereço do Contrato:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      testamento["endereco"]!,
                      style: const TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Valor:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              testamento["valor"]!,
                              style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Abrindo ${testamento["titulo"]}")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text("Ver Detalhes"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Adicionar novo testamento")),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
