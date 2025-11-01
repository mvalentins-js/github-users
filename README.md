# SF Users

SF Users is a simple iOS application that fetches and displays the top Stack Overflow users by reputation using the Stack Exchange API.  
The app demonstrates the use of clean architecture, MVVM pattern, repository abstraction, and local persistence via `UserDefaults`.

---

## 🚀 Features

- Fetch Stack Overflow users (top 20 by reputation). Empty state view shown when there are no users to display.
- Follow/unfollow users and persist their state across app sessions
- Dependency injection for testing and flexibility
- Coordinator pattern for navigation and alerts
- Lightweight local caching using `UserDefaults`
- Unit tests with mock services and repositories
- Displays an **alert** when a network or API error occurs to inform the user something went wrong

---

## 🧩 Architecture Overview

The app follows **MVVM + Repository** architecture:

```
ViewController ↔ ViewModel ↔ Repository ↔ API / Local Storage
```

- **ViewController (UIKit)**: Handles UI and user interactions, including showing alerts on errors.
- **ViewModel**: Contains presentation logic, fetches data, and maintains the view state.
- **Repository**: Serves as a bridge between network and local data.
- **LocalDataService**: Persists followed users.
- **APIService**: Handles remote network calls to Stack Exchange API.

---

## 🧱 Technical Decisions

- **UserDefaults** used for lightweight persistence instead of Core Data, since only small key-value data is stored.
- **Repository layer** abstracts both API and local services for easier testing.
- **async/await** is used for modern and clean asynchronous operations.
- **MVVM pattern** improves testability and separation of concerns.
- **Coordinator pattern** handles navigation and error alert presentation.
- **Mock classes** are used for unit testing to avoid real network calls.
- **Error handling** via ViewModel triggers a closure to show an alert (`UIAlertController`) through the ViewController when a network or decoding issue occurs.

---

## 🧪 Testing

The project includes unit tests for:
- `SFUserViewModel`
- `SFRepository` using `MockAPIService` and `MockLocalDataService`

Mocks simulate API responses and local persistence.

Run tests using:
```bash
Cmd + U
```

---

## ⚙️ Installation & Setup

1. Clone the repository:
   ```bash
   https://github.com/mvalentins-js/github-users.git
   ```

2. Open the project in Xcode:
   ```bash
   open SFUsers.xcodeproj
   ```

3. Build and run the project on an iOS Simulator (iOS 17+ recommended).

---

## 🌐 API Reference

The app uses the [Stack Exchange API](https://api.stackexchange.com/2.2/users) endpoint:

```
https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow
```

---

## 📸 UI Overview

- **User List Screen**: Displays top users with their name, reputation, and profile image.
- **Follow Button**: Allows following/unfollowing a user.
- **Checkmark Overlay**: Indicates followed state on profile image.
- **Error Alert**: If a network issue occurs, an alert is shown using `UIAlertController` to notify the user that something went wrong and they can retry later.

---

## 🧑‍💻 Author

Developed by **Monika Stoyanova**  
iOS Developer | Swift | UIKit | MVVM
