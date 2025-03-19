pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        gradlePluginPortal()
        google()
        mavenLocal()
        mavenCentral()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.6.0" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false

//    id("com.android.application") version "8.3.0" apply false
//    id("org.jetbrains.kotlin.android") version "1.9.0" apply false
//    id("com.google.gms.google-services") version "4.4.2" apply false


//    id("org.jetbrains.dokka") version "1.9.0" apply false
//    id("org.gradle.toolchains.foojay-resolver-convention") version("0.8.0")
}

include(":app")
//
//rootProject.name = "MetaMaskAndroidSDKClient"
//include(":metamask-android-sdk")
