# Pharos 🕯️

**Pharos** is a focus-driven reading companion designed to provide a sanctuary for deep reading. By combining immersive ambient soundscapes with AI-powered organizational tools, it helps users eliminate distractions and transform their reading sessions into structured insights.



## 🌟 Features

* **Immersive Audio Sessions:** Integrated background atmospheres (rain, library, white noise) using **AVFoundation** to foster a state of flow.
* **Active Note-Taking:** Capture thoughts in real-time during sessions or reflect on your progress afterward.
* **AI Summarization:** Leverage **Foundation Models** to automatically generate concise summaries of your reading notes.
* **Smart Auto-Titling:** Pharos analyzes your notes to suggest contextually relevant titles automatically using AI.
* **Local Persistence:** High-performance data handling with **SwiftData**, keeping your library and insights synced and secure on your device.

## 🛠 Tech Stack

* **Language:** Swift 5.10+
* **UI Framework:** SwiftUI
* **Data Management:** SwiftData
* **Audio Engine:** AVFoundation
* **Intelligence:** Foundation Models (On-device processing)

## 📸 Interface

| Reading Focus | Note Summarization | Library Tracking |
| :--- | :--- | :--- |
| ![Focus Mode](https://via.placeholder.com/200x400) | ![AI Summary](https://via.placeholder.com/200x400) | ![SwiftData Library](https://via.placeholder.com/200x400) |

## 🚀 Getting Started

### Prerequisites
* Xcode 15.0 or later
* iOS 17.0+ / macOS 14.0+

### Installation
1.  Clone the repository:
    ```bash
    git clone [https://github.com/yourusername/Pharos.git](https://github.com/yourusername/Pharos.git)
    ```
2.  Open `Pharos.xcodeproj` in Xcode.
3.  Ensure your development team is selected in **Signing & Capabilities**.
4.  Build and Run (**Cmd + R**).

## 🏗 Architecture

The project follows a modern, reactive architecture:



* **Views:** Pure SwiftUI for a fluid, native experience.
* **Data:** **SwiftData** `@Model` containers for seamless persistence and schema migrations.
* **Logic:** Decoupled services for Audio handling and AI inference to ensure the UI remains responsive.

## ⚖️ License

Distributed under the MIT License. See `LICENSE` for more information.

---
*Developed with ❤️ as part of a deep reading exploration.*
