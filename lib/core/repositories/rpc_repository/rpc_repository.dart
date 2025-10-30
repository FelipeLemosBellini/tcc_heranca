import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class RpcRepository {
  Future<EtherAmount> getEthBalance(String rpcUrl, String walletAddress) async {
    final client = Web3Client(rpcUrl, Client());
    final address = EthereumAddress.fromHex(walletAddress);
    final balance = await client.getBalance(address);
    client.dispose();
    return balance;
  }
}