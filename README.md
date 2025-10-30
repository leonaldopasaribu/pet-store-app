# 🐾 Pet Store App

A modern Flutter mobile application for browsing pets and managing orders. Built with **Clean Architecture**, **Flutter**, and **Dart**, powered by the PetStore API.

## 🎬 Demo

![App Demo](https://github.com/user-attachments/assets/2a8466fd-d856-4f70-bade-9cc65f057f79)

**Features Showcase:**
- Browse available pets
- View pet details
- Add pets to cart
- Complete checkout process


## 🛠️ Tech Stack

- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **Architecture:** Clean Architecture + Repository Pattern
- **HTTP Client:** Dio (via ApiClient)
- **API:** [PetStore API v3](https://petstore3.swagger.io/)

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:
- **Flutter SDK** (3.0.0 or higher)
- **Dart SDK** (3.0.0 or higher)
- **Android Studio** / **Xcode** (for mobile development)
- **Git**

Check Flutter installation:
```bash
flutter --version
flutter doctor
```

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/petstoreapp.git
cd petstoreapp
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices
flutter run -d <device_id>
```

4. **Build for production:**
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🔌 API Integration

This application uses the **PetStore API v3** for all backend operations.

**Base URL:** `https://petstore3.swagger.io/api/v3`

### Implemented Endpoints

#### Pet Operations
```dart
// Fetch pets by status
GET /pet/findByStatus?status={available|pending|sold}

// Fetch single pet by ID
GET /pet/{petId}
```

#### Order Operations
```dart
// Create new order
POST /store/order
Body: {
  "id": 0,
  "petId": 0,
  "quantity": 0,
  "shipDate": "2025-10-30T00:00:00.000Z",
  "status": "placed",
  "complete": true
}
```

### Repository Implementation Example

**Pet Repository:**
```dart
class PetRepositoryImpl implements PetRepository {
  final ApiClient apiClient;
  
  @override
  Future<List<PetEntity>> fetchAll({String? status}) async {
    final response = await apiClient.get(
      '/pet/findByStatus',
      queryParameters: {'status': status ?? 'available'},
    );
    // Handle response and return entities
  }
}
```

**Order Repository:**
```dart
class OrderRepositoryImpl implements OrderRepository {
  final ApiClient apiClient;
  
  @override
  Future<OrderEntity> create(OrderEntity order) async {
    final response = await apiClient.post(
      '/store/order',
      data: orderModel.toJson(),
    );
    // Handle response and return entity
  }
}
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- 🚧 Web

## 👨‍💻 Author

**Leonaldo Pasaribu**
- GitHub: [@leonaldopasaribu](https://github.com/leonaldopasaribu)
- LinkedIn: [Leonaldo Pasaribu](https://linkedin.com/in/leonaldo-pasaribu)

## 🙏 Acknowledgments

- [PetStore API](https://petstore3.swagger.io/) - Backend API provider
- [Flutter Team](https://flutter.dev/) - Amazing framework
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Architecture pattern by Uncle Bob
- [Front-end Architecture with Angular](https://medium.com/@leonaldopasaribu/front-end-architecture-with-angular-74ffa922ca8f) - Architecture inspiration and best practices

---

⭐ **If you like this project, please give it a star!** ⭐

Made with ❤️ using Flutter
