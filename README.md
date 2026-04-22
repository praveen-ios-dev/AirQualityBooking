# 🌍 AirQualityBooking

AirQualityBooking is a modern iOS application built using **SwiftUI** that demonstrates a scalable architecture for handling real-world features like air quality tracking, location selection, and booking workflows.

The project focuses on **Clean Architecture**, **MVVM**, and **Dependency Injection** using Factory, with support for both **real and mock APIs**.

---

## 🚀 Features

* 📍 Select two locations on map
* 🌫️ Fetch air quality data
* 🧾 Create booking between locations
* 🔄 Support for real + mock APIs (per feature)
* ⚡ Built using Swift Concurrency (`async/await`)
* 🧪 Easily testable architecture

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles:

* **Presentation Layer**

  * SwiftUI
  * MVVM (`@Observable`, ViewModels)

* **Domain Layer**

  * UseCases (e.g. `CreateBookingUseCase`)
  * Business logic abstraction

* **Data Layer**

  * Repository pattern
  * DTO → Domain mapping
  * Network services (Real & Mock)

---

## 🔌 Dependency Injection

Dependency Injection is handled using Factory:

* Supports **per-service configuration**
* Easily switch between **Mock & Real APIs**
* Enables **testability and modularity**

---

## 🌐 API Strategy

The app supports a hybrid API approach:

* Some services use **real APIs**
* Others use **mock implementations**

This is controlled via configuration, allowing flexibility for:

* Development
* Testing
* Feature isolation

---

## 🧵 Concurrency

* Built using **Swift Concurrency**
* Uses `async/await`
* `@MainActor` for UI safety

---

## 🧪 Testing

* Mock repositories and services
* Designed for unit testing ViewModels & UseCases

---

## 📦 Tech Stack

* **Language:** Swift
* **UI:** SwiftUI
* **Architecture:** MVVMC + Clean Architecture
* **DI:** Factory
* **Concurrency:** async/await
* **Testing:** XCTest

---

## 📸 Screenshots (Optional)

<p align="center">
  <img src="https://github.com/user-attachments/assets/e2af9fd1-af3e-45ab-a754-3b88fbcaa96a" width="120"/>
  <img src="https://github.com/user-attachments/assets/1e4dcd2b-a821-452d-9ff1-07874ecb19db" width="120"/>
  <img src="https://github.com/user-attachments/assets/7489771f-e5c2-4931-af58-c66c4006b88c" width="120"/>
  <img src="https://github.com/user-attachments/assets/f9081f05-dec2-4123-81e3-8e6bbf4ddb5e" width="120"/>
  <img src="https://github.com/user-attachments/assets/2e496270-9d3b-4015-8d46-c2e71d072849" width="120"/>
  <img src="https://github.com/user-attachments/assets/dfd2d33b-d84a-4ab1-9e29-3e1618e04a20" width="120"/>
  <img src="https://github.com/user-attachments/assets/6cc6980f-ef60-4026-93f1-eca0f893d4e2" width="120"/>
</p>

## 🛠️ Setup

```bash
git clone https://github.com/your-username/AirQualityBooking.git
cd AirQualityBooking
open AirQualityBooking.xcodeproj
```

---

## 👨‍💻 Author

**Praveen Kumar**
---

## ⭐️ Why This Project?

This project showcases:

* Scalable iOS architecture
* Real-world problem solving
* Production-level coding practices

---

## 📬 Feedback

Feel free to open issues or contribute!
