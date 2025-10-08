# 📱 Task & Expense Manager - Ứng dụng Quản lý Công việc & Chi tiêu Thông minh

Ứng dụng quản lý chi tiêu và công việc thông minh với tích hợp AI, được phát triển bằng Flutter và hỗ trợ đa nền tảng.

## 🌟 Tổng quan

Task & Expense Manager là một ứng dụng toàn diện giúp người dùng quản lý tài chính cá nhân và công việc hàng ngày một cách hiệu quả. Ứng dụng kết hợp công nghệ AI tiên tiến để cung cấp những phân tích và gợi ý thông minh, giúp người dùng đưa ra quyết định tài chính tốt hơn.

### ✨ Điểm nổi bật

- 🤖 **AI Assistant tích hợp**: Chat trực tiếp với AI để được tư vấn tài chính và công việc
- 📋 **Task Management thông minh**: Quản lý công việc với AI suggestions
- 💰 **Expense Tracking chi tiết**: Theo dõi chi tiêu với phân tích xu hướng
- 📊 **Budget Management**: Ngân sách thông minh với cảnh báo real-time
- 📈 **Reports & Analytics**: Báo cáo trực quan với AI insights
- 🔒 **Bảo mật cao**: Firebase Auth với multi-layer security
- 🌍 **Đa ngôn ngữ**: Hỗ trợ Tiếng Việt và English

## 💎 Giá trị cốt lõi

- **Quản lý tài chính thông minh**: Theo dõi chi tiêu, tạo ngân sách và nhận cảnh báo kịp thời
- **Tích hợp công việc**: Liên kết chi phí với công việc để theo dõi hiệu quả tài chính
- **AI Insights**: Phân tích hành vi chi tiêu và đưa ra gợi ý cá nhân hóa
- **Trải nghiệm người dùng tối ưu**: Interface hiện đại, responsive trên mọi thiết bị
- **Đồng bộ đám mây**: Dữ liệu được lưu trữ an toàn trên Firebase

## 🚀 Chức năng chính

### 📊 Quản lý chi tiêu

- **Ghi nhận chi tiêu đa dạng**: Hỗ trợ nhiều loại chi phí với phân loại chi tiết
- **Theo dõi tâm trạng**: Ghi nhận cảm xúc khi chi tiêu để phân tích hành vi
- **Lý do chi tiêu**: Ghi chép và phân tích nguyên nhân chi tiêu
- **Đính kèm hình ảnh**: Lưu trữ hóa đơn và bằng chứng chi tiêu
- **Xuất báo cáo**: Chia sẻ dữ liệu chi tiêu dưới nhiều định dạng

### 💰 Quản lý ngân sách

- **Tạo ngân sách thông minh**: Templates được AI gợi ý phù hợp với hành vi người dùng
- **Cảnh báo ngân sách**: Thông báo khi chi tiêu vượt ngưỡng
- **Theo dõi chu kỳ**: Hỗ trợ ngân sách hàng ngày, tuần, tháng, năm
- **Phân tích xu hướng**: Đánh giá hiệu quả ngân sách qua thời gian

### ✅ Quản lý công việc

- **Tạo và theo dõi task**: Quản lý công việc với độ ưu tiên và deadline
- **Liên kết chi phí**: Tính toán chi phí thực tế cho từng công việc
- **Theo dõi hiệu suất**: Phân tích tỷ lệ hoàn thành và hiệu quả
- **Phân loại công việc**: Tổ chức theo danh mục và dự án

### 🤖 AI & Phân tích thông minh

- **Gemini AI Integration**: Sử dụng Google Gemini để phân tích dữ liệu
- **Dự đoán chi tiêu**: Forecast xu hướng chi tiêu tương lai
- **Phát hiện bất thường**: Cảnh báo các khoản chi tiêu bất thường
- **Gợi ý cá nhân hóa**: Đưa ra khuyến nghị dựa trên hành vi người dùng
- **Báo cáo thông minh**: Tạo insights tự động từ dữ liệu

## 🏗️ Kiến trúc & Công nghệ

### 🎯 Clean Architecture

Dự án được xây dựng theo mô hình **Clean Architecture** với 3 lớp chính:

```
📦 lib/
├── 🔧 core/                          # Các thành phần cốt lõi
│   ├── constants/                    # Hằng số và cấu hình
│   │   ├── app_enums.dart           # Enum definitions
│   │   ├── firebase_config.dart     # Firebase configuration
│   │   └── theme_config.dart        # Theme settings
│   ├── l10n/                        # Đa ngôn ngữ (Vi/En)
│   ├── services/                    # Dịch vụ chung
│   │   ├── ai_service.dart          # AI integration service
│   │   ├── advanced_ai_service.dart # Advanced AI features
│   │   └── file_export_service.dart # Export functionality
│   └── utils/                       # Tiện ích và helpers
├── 🎯 features/                      # Các tính năng chính
│   ├── 🔐 auth/                     # Authentication
│   ├── 🤖 ai/                       # AI Assistant & Chat
│   │   ├── ai_controller.dart       # AI state management
│   │   ├── ai_chat_screen.dart      # Chat interface
│   │   ├── models/chat_message.dart # Chat data models
│   │   └── widgets/                 # AI-specific widgets
│   ├── 📋 task/                     # Task Management
│   ├── 💰 expense/                  # Expense Tracking
│   ├── 💳 budget/                   # Budget Management
│   ├── 📊 reports/                  # Reports & Analytics
│   ├── 📅 calendar/                 # Calendar Integration
│   └── 👤 profile/                  # User Profile
└── 🛣️ routes/                       # App Navigation
```

### 🛠️ Tech Stack

#### Core Technologies

- **Flutter 3.24.3**: Cross-platform mobile framework
- **Dart**: Primary programming language
- **GetX**: State management, routing, dependency injection
- **Firebase**: Backend-as-a-Service platform

#### Key Dependencies

```yaml
dependencies:
  get: ^4.6.6 # State management
  firebase_core: ^2.24.2 # Firebase core
  firebase_auth: ^4.15.3 # Authentication
  cloud_firestore: ^4.13.6 # NoSQL database
  freezed: ^2.4.6 # Code generation
  injectable: ^2.3.2 # Dependency injection
  fl_chart: ^0.65.0 # Charts and graphs
  flutter_animate: ^4.5.0 # Smooth animations
```

### 🤖 AI Integration Architecture

```dart
AIService
├── analyzeExpenses()      # Phân tích chi tiêu
├── analyzeTasks()         # Phân tích công việc
├── getSmartSuggestions()  # Gợi ý thông minh
├── getChatResponse()      # Chat với AI
└── getPredictiveAnalysis() # Dự đoán xu hướng
```

## 💬 AI Chat System

### Luồng Chat với AI

1. **Khởi tạo**: AI gửi tin nhắn chào mừng
2. **User input**: Người dùng nhập câu hỏi/yêu cầu
3. **Processing**: AI phân tích context và dữ liệu user
4. **Response**: AI trả lời với insights và suggestions
5. **Follow-up**: AI có thể đưa ra câu hỏi tiếp theo

### AI Capabilities

- 💰 **Expense Analysis**: "Phân tích chi tiêu tháng này"
- 📊 **Budget Insights**: "Ngân sách nào tôi đang vượt?"
- 📋 **Task Optimization**: "Làm sao tối ưu công việc?"
- 🔮 **Predictions**: "Dự đoán chi tiêu tháng sau"
- 💡 **Smart Tips**: Gợi ý tiết kiệm và hiệu quả

### Context-Aware Suggestions

AI hiểu context thời gian và đưa ra gợi ý phù hợp:

- 🌅 **Buổi sáng**: "Lập kế hoạch công việc hôm nay"
- ☕ **Buổi trưa**: "Review tiến độ và ghi chi tiêu"
- 🌙 **Buổi tối**: "Tổng kết ngày và chuẩn bị ngày mai"

## 🚀 Tính năng nâng cao

### 📊 Advanced Analytics

- Trend analysis với machine learning
- Anomaly detection cho chi tiêu bất thường
- Predictive modeling cho ngân sách
- Behavioral pattern recognition

### 🔄 Real-time Features

- Live budget tracking
- Instant AI recommendations
- Real-time collaboration (future)
- Push notifications thông minh

### 📱 Cross-platform Support

- Android: Native performance
- iOS: Seamless integration
- Web: Responsive design (future)
- Desktop: Full-featured app (future)

## 📈 Performance & Optimization

- **State Management**: GetX cho performance tối ưu
- **Lazy Loading**: Load data khi cần thiết
- **Image Caching**: Cache ảnh để tăng tốc độ
- **Offline Support**: Hoạt động khi mất mạng
- **Memory Management**: Tự động dọn dẹp memory

## 🎨 UI/UX Design

- **Material Design 3**: Modern và intuitive
- **Dark/Light Mode**: Hỗ trợ cả 2 theme
- **Responsive**: Tối ưu cho mọi screen size
- **Accessibility**: Tuân thủ accessibility standards
- **Smooth Animations**: Flutter Animate integration

## 📱 Demo Workflow

### 1. Ghi nhận chi tiêu thông minh

### Clean Architecture

- **Presentation Layer**: UI/UX với GetX state management
- **Domain Layer**: Business logic và use cases
- **Data Layer**: Repository pattern với Firebase integration

### Công nghệ sử dụng

- **Frontend**: Flutter 3.0+ với Material Design
- **State Management**: GetX framework
- **Backend**: Firebase (Firestore, Auth, Storage)
- **AI Service**: Google Generative AI (Gemini)
- **Local Storage**: SharedPreferences
- **Dependency Injection**: Injectable + GetIt
- **Code Generation**: Freezed, JSON Serializable

## 📱 Luồng sử dụng chính

### 1. Quản lý chi tiêu hàng ngày

```
Mở app → Trang chủ → "Thêm chi tiêu"
→ Chọn danh mục → Nhập số tiền → Chọn tâm trạng
→ Ghi chú lý do → Đính kèm ảnh → Lưu
```

### 2. Thiết lập ngân sách

```
Menu → Ngân sách → "Tạo ngân sách mới"
→ Chọn template AI → Điều chỉnh số tiền
→ Thiết lập cảnh báo → Xác nhận tạo
```

### 3. Quản lý công việc

```
Menu → Công việc → "Tạo task mới"
→ Nhập thông tin → Liên kết chi phí dự kiến
→ Thiết lập deadline → Theo dõi tiến độ
```

### 4. Xem báo cáo AI

```
Trang chủ → "AI Insights" → Xem phân tích
→ Dự đoán xu hướng → Nhận gợi ý → Áp dụng khuyến nghị
```

## 🎯 Đối tượng người dùng

- **Cá nhân**: Quản lý tài chính và công việc cá nhân
- **Sinh viên**: Theo dõi chi tiêu học tập và sinh hoạt
- **Freelancer**: Quản lý chi phí dự án và công việc
- **Gia đình nhỏ**: Lập ngân sách và theo dõi chi tiêu gia đình

## 🔐 Bảo mật và quyền riêng tư

- **Xác thực Firebase**: Đăng nhập an toàn với email/password
- **Mã hóa dữ liệu**: Tất cả dữ liệu được mã hóa trên Firestore
- **Quyền riêng tư**: Dữ liệu cá nhân được bảo vệ theo GDPR
- **Backup tự động**: Đồng bộ đám mây để tránh mất dữ liệu

## 🌍 Hỗ trợ đa ngôn ngữ

- Tiếng Việt (chính)
- English (hỗ trợ)
- Tự động phát hiện ngôn ngữ hệ thống

## 📈 Lộ trình phát triển

### Phiên bản hiện tại (v1.0.0)

- ✅ Quản lý chi tiêu cơ bản
- ✅ Ngân sách thông minh
- ✅ Tích hợp AI Gemini
- ✅ Quản lý công việc

### Phiên bản tiếp theo (v1.1.0)

- 🔄 Đồng bộ multi-device
- 🔄 Báo cáo nâng cao
- 🔄 Widget trang chủ
- 🔄 Export Excel/PDF

## 🚀 Hướng dẫn cài đặt

### Yêu cầu hệ thống

## 🚀 Cài đặt & Phát triển

### Prerequisites

- Flutter SDK >=3.24.3
- Dart SDK >=3.5.0
- Android Studio / VS Code
- Firebase project setup
- Google AI API key

### Setup Steps

1. **Clone repository**

```bash
git clone https://github.com/haianhnitc/Work-and-spending-management-application-personal-income.git
cd task_expense_manager
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Firebase Configuration**

```bash
# Thêm google-services.json vào android/app/
# Thêm GoogleService-Info.plist vào ios/Runner/
# Cấu hình Firestore rules
# Enable Authentication methods
```

4. **Generate Code**

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

5. **Run Application**

```bash
# Development
flutter run

# Release build
flutter build apk --release
flutter build ios --release
```

### Development Commands

```bash
# Code generation
flutter packages pub run build_runner watch

# Generate translations
flutter gen-l10n

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

## 🧪 Testing

### Test Structure

```
test/
├── unit/           # Unit tests
├── widget/         # Widget tests
├── integration/    # Integration tests
└── mocks/          # Mock objects
```

### Run Tests

```bash
# All tests
flutter test

# Specific test
flutter test test/unit/ai_service_test.dart

# Coverage report
flutter test --coverage
```

## 🔧 Configuration

### Environment Setup

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String apiKey = 'YOUR_AI_API_KEY';
  static const String baseUrl = 'https://api.example.com';
  static const bool debugMode = true;
}
```

### Firebase Rules Example

```javascript
// Firestore Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /expenses/{document} {
      allow read, write: if request.auth != null &&
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## � Roadmap & Future Features

### Phase 1: Core Enhancement (Q4 2025)

- [ ] Advanced AI models integration
- [ ] Real-time collaboration features
- [ ] Enhanced data visualization
- [ ] Offline-first architecture

### Phase 2: Platform Expansion (Q1 2026)

- [ ] Web application (Flutter Web)
- [ ] Desktop application (Windows/macOS/Linux)
- [ ] API for third-party integrations
- [ ] Advanced export formats

### Phase 3: Intelligence & Automation (Q2 2026)

- [ ] Machine learning personalization
- [ ] Automated categorization
- [ ] Smart notifications system
- [ ] Predictive budgeting

### Phase 4: Enterprise Features (Q3 2026)

- [ ] Team collaboration tools
- [ ] Multi-currency support
- [ ] Advanced reporting
- [ ] Integration with banking APIs

## 🤝 Contributing

### How to Contribute

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Coding Standards

- Follow Flutter/Dart conventions
- Use Clean Architecture principles
- Write comprehensive unit tests
- Document public APIs
- Follow conventional commits

### Pull Request Process

1. Update README.md with details of changes
2. Update version numbers following SemVer
3. Include tests for new functionality
4. Ensure CI/CD pipeline passes
5. Request review from maintainers

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** - Amazing cross-platform framework
- **Firebase Team** - Reliable backend services
- **GetX Community** - Excellent state management
- **Google AI** - Powerful AI integration
- **Open Source Community** - Inspiration and support

## 👨‍💻 Author & Maintainer

**Hai Anh NITC**

- GitHub: [@haianhnitc](https://github.com/haianhnitc)
- Email: haianhnitc@gmail.com
- LinkedIn: [Hai Anh NITC](https://linkedin.com/in/haianhnitc)

## 📞 Support & Contact

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/haianhnitc/Work-and-spending-management-application-personal-income/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/haianhnitc/Work-and-spending-management-application-personal-income/discussions)
- 📧 **Email Support**: haianhnitc@gmail.com
- 💬 **Community**: [Discord Server](#) (Coming Soon)

## 📈 Project Stats

![Flutter](https://img.shields.io/badge/Flutter-3.24.3-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.5.0-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

---

### 🎯 Mission Statement

**"Empowering individuals to achieve financial wellness and productivity through intelligent technology."**

### ⭐ Show Your Support

If you find this project helpful, please consider giving it a ⭐ on GitHub!

---

**Task & Expense Manager** - Quản lý thông minh, sống hiệu quả! 🎯✨
