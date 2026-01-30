plugins {
    id("com.android.application")
    id("kotlin-android")
    // Este es el plugin que conecta Flutter con Android
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.app_unmsm" // Asegúrate que coincida con tu package
    compileSdk = 35 // O el que tengas instalado

    defaultConfig {
        applicationId = "com.example.app_unmsm"
        minSdk = 24
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}