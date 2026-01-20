# 📊 SIP Calculator App (Flutter)

A modern **SIP (Systematic Investment Plan) Calculator** built using **Flutter**, designed to help users calculate, analyze, and save their investment plans. The app provides accurate SIP calculations, estimated invested amount, wealth gained, and year-wise projections with a clean and responsive UI.

---

## ✨ Features

* 📈 SIP calculation using compound interest
* 💰 Estimated total invested amount
* 🚀 Wealth gained calculation
* 📅 Year-wise SIP calculation & projection
* 💾 Save and manage SIP investment plans
* ⚡ Smooth and responsive UI
* 🔄 State management using **Provider**
* 📱 Adaptive layout using `flutter_screenutil`

---

## 📸 Screenshots

| SIP Input                              | Calculated Returns                  | Saved Plan                       |
| -------------------------------------- |-------------------------------------|----------------------------------|
| ![](screenshots/calculation_input.png) | ![](screenshots/calculated_sip.png) | ![](screenshots/saved_plans.png) |

> 📌 Screenshots are taken from the latest development build.

---

## 🧮 SIP Formula Used

```
A = P × (( (1 + r)^n − 1 ) / r) × (1 + r)
```

Where:

* **A** → Future value of SIP
* **P** → Monthly investment amount
* **r** → Monthly rate of return
* **n** → Total number of months

---

## 🏗️ Project Architecture

The app follows a **feature-based architecture** with clear separation of concerns and scalable structure.

```
assets/
│
├── icons/
├── images/
│
lib/
│
├── features/
│   └── sip_calculation/
│       ├── model/
│       ├── provider/
│       └── screens/
│
├── utils/
│   ├── app_text_style.dart
│   └── colors.dart
│
├── widgets/
│
└── main.dart
```

### 🔹 Architecture Overview

* **features/** → Feature-wise modular structure
* **model/** → SIP data models & projection entities
* **provider/** → Business logic & state management
* **screens/** → UI screens for SIP flow
* **widgets/** → Reusable UI components
* **utils/** → App-wide text styles, colors & constants
* **assets/** → Icons and image resources

---

## 🛠️ Tech Stack

* **Flutter**
* **Dart**
* **Provider** (State Management)
* **flutter_screenutil**
* **Material Design**

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK (latest stable)
* Dart SDK
* Android Studio / VS Code

### Installation

```bash
git clone https://github.com/your-username/sip-calculator-flutter.git
cd sip-calculator-flutter
flutter pub get
flutter run
```

---

## 🔮 Future Enhancements

* 📊 SIP growth charts & graphs
* 📤 Export SIP report (PDF / Excel)
* ☁️ Cloud backup for saved plans
* 🌙 Dark & Light theme support

---

## 🤝 Contributing

Contributions are welcome!
Feel free to fork this repository, create a feature branch, and submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License**.

---

⭐ If you find this project helpful, don’t forget to **star the repository**!
