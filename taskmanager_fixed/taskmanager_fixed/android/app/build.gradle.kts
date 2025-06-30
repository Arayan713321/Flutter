plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.taskmanager_fixed"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Required for flutter_local_notifications and sqflite_android

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true // Required for flutter_local_notifications
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.taskmanager_fixed"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4") // Desugaring for Java 8+ features
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.24") // Fixed Kotlin version
}

flutter {
    source = "../.."
}