package com.tcc_heranca

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

//import io.metamask.androidsdk.Ethereum
//import io.metamask.androidsdk.Ethereum

class MainActivity : FlutterActivity() {
//    private val CHANNEL = "metamask_sdk"
//    private lateinit var metaMaskSDK: MetaMaskSDK
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        metaMaskSDK = MetaMaskSDK(
//            context = this,
//            dAppUrl = "https://www.youtube.com/"
//        )
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "connectMetaMask" -> connectToMetaMask(result)
//                else -> result.notImplemented()
//            }
//        }
//    }
//
//    private fun connectToMetaMask(result: MethodChannel.Result) {
//        metaMaskSDK.connect(
//            onSuccess = { walletInfo ->
//                val address = walletInfo.accounts.firstOrNull()
//                result.success(address)
//            },
//            onError = { error: MetaMaskSDKError ->
//                result.error("METAMASK_ERROR", error.message, null)
//            }
//        )
//    }
}
