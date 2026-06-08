# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Retrofit / OkHttp
-keepattributes Signature
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn retrofit2.**

# dart_mappable — keep generated mapper classes
-keep class **Mapper { *; }
-keep @com.google.gson.annotations.SerializedName class * { *; }

# Riverpod / Flutter Riverpod
-keep class dev.rndi.** { *; }

# Keep all app model/entity classes (used via reflection in dart_mappable)
-keep class com.bhumijo.facilityapp.** { *; }

# Play Core (deferred components — not used, suppress missing class warnings)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Geolocator / location plugins
-keep class com.baseflow.geolocator.** { *; }

# Camera / image picker
-keep class io.flutter.plugins.camera.** { *; }
-keep class io.flutter.plugins.imagepicker.** { *; }
