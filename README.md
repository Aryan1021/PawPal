# PawPal 🐾

PawPal is a Flutter-based mobile app that helps users browse, favorite, and adopt pets seamlessly. Built with a clean architecture, it features light/dark theme switching, local persistence using Hive, and engaging UI components like hero animations and pull-to-refresh.

---

##  Table of Contents

- [Features](#features)  
- [Screenshots & Demo](#screenshots--demo)  
- [Installation](#installation)  
- [Project Structure](#project-structure)  
- [How to Build & Run](#how-to-build--run)  
- [Tech Stack](#technology-stack)  
- [Contributing](#contributing)  
- [License](#license)

##  Features
- Browse pets with dynamic filters and search
- Mark pets as favorites
- Adopt pets (status persisted locally)
- Switch between Light and Dark themes
- Smooth animations and responsive UI across pages

---

##  APK 

- **Download the APK**: [Download PawPal APK](https://github.com/user-attachments/files/21741300/app-release.zip)

---

## Demo Video

- ![PawPal Demo](https://github.com/user-attachments/assets/a2763a68-d039-464e-9494-3e33080b7363)

---

##  Installation

1. Clone the repo:
   ```sh
   git clone https://github.com/Aryan1021/PawPal.git
   cd PawPal
   ```

2. Install dependencies:
  ```sh
  flutter pub get
  ```

---

## Project Structure

<img width="360" height="927" alt="Screenshot 2025-08-12 181932" src="https://github.com/user-attachments/assets/c49ede31-9d09-4f54-a768-145a0ec14581" />

---

## How to Build & Run
- Run on emulator/device:
  ```sh
  flutter run
  ```
  
- APK build:
  ```sh
  flutter build apk --release
  ```
(Generated APK is in build/app/outputs/flutter-apk/app-release.apk)

- Install APK on device:
  ```sh
  adb install build/app/outputs/flutter-apk/app-release.apk
  ```

---

## 🛠 Tech Stack

| Layer         | Technology / Package |
| ------------- | -------------------- |
| **Framework** | <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white" /> <img src="https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white" /> |
| **Persistence** | <img src="https://img.shields.io/badge/Hive-F7A41D?logo=hive&logoColor=white" /> |
| **State Management** | <img src="https://img.shields.io/badge/Provider-448AFF?logo=flutter&logoColor=white" /> |
| **UI** | Hero Transitions, AnimatedSwitcher, RefreshIndicator, etc. |
| **Theming** | Dynamic Light/Dark Theme via Provider |

---

## Contributing
- Want to contribute? All contributions are welcome! Please:
1. Fork the repo
2. Create a new branch (git checkout -b feature/xyz)
3. Make your changes & commit (git commit -m "feat: ..." )
4. Push branch and open a Pull Request

---

## License
- Distributed under the MIT License. See LICENSE for details.

---

## 👨‍💻 Author
Aryan Raj
