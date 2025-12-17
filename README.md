

﻿
# 📝 Flutter Notes App (Offline + Auth)

A simple **offline-first Notes application** built with **Flutter** and **Hive**, featuring **local authentication**, **note CRUD**, and **search functionality**.

This project is focused on understanding **Flutter app structure**, **stateful widgets**, and **local persistence** without relying on any backend or cloud services.

## Preview
<img width="466" height="400" alt="image" src="https://github.com/user-attachments/assets/0216ee6f-e1bb-4b90-b7b9-a4fd13c2fc76" />

---

 
## ✨ Features

- 🔐 Local authentication (Login / Sign Up)
- 🗂 Persistent notes using Hive (offline storage)
- ➕ Add, ✏️ edit, ❌ delete notes
- 🔍 Real-time note search
- 🎨 Dark-themed UI
- 🚪 Auth gate to auto-redirect logged-in users

---

## 🧠 How It Works

### Authentication
- Credentials are stored locally using **Hive**
- Logged-in user is tracked via `authBox`
- `AuthGate` decides whether to show:
  - `LoginPage`
  - or `NotesHomePage`

```dart
currentUser != null ? NotesHomePage() : LoginPage()
