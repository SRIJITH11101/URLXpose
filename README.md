# 🔍 URLXpose

URLXpose is a Flutter-based mobile application that helps users expand and check the safety of shortened or suspicious URLs. It uses Google's Safe Browsing API to detect threats like malware or social engineering.

## 🚀 Features

- 🔗 Expand shortened URLs (like bit.ly, tinyurl, etc.)
- 🛡️ Check URL safety using Google Safe Browsing API
- ⚠️ Displays threat types and platform information if the URL is malicious
- 📱 Mobile-responsive, smooth UI
- ✅ Works on Android (tested with release APK)

## 📸 Screenshots

*(Add screenshots of your app here)*

## 🧰 Tech Stack

- Flutter
- Dart
- HTTP Package
- Google's Safe Browsing API

## 🔧 Installation

1. **Clone the repo**
   ```bash
   git clone https://github.com/your-username/urlxpose.git
   cd urlxpose
Install dependencies

bash
Copy
Edit
flutter pub get
Run the app

bash
Copy
Edit
flutter run
📱 APK Build
To build the release APK:

bash
Copy
Edit
flutter build apk --release
The APK will be generated under: build/app/outputs/flutter-apk/app-release.apk

🔑 Permissions
The app requires the following permission in AndroidManifest.xml:

xml
Copy
Edit
<uses-permission android:name="android.permission.INTERNET"/>
🛡️ Google Safe Browsing API
Make sure to get your API key from Google Safe Browsing API and add it to your project in the proper place.

🙌 Acknowledgements
Flutter & Dart

Google Safe Browsing API

StackOverflow and Flutter Dev Community ❤️
