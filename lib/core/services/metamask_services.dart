import 'package:flutter/services.dart';

class MetaMaskService {
  static const MethodChannel _channel = MethodChannel('metamask_sdk');

  static Future<String?> connectMetaMask() async {
    try {
      final String? walletAddress = await _channel.invokeMethod('connectMetaMask');
      return walletAddress;
    } catch (e) {
      print("Erro ao conectar à MetaMask: $e");
      return null;
    }
  }
}