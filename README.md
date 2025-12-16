

﻿
# 📝 Flutter Notes App (Offline + Auth)

A simple **offline-first Notes application** built with **Flutter** and **Hive**, featuring **local authentication**, **note CRUD**, and **search functionality**.

This project is focused on understanding **Flutter app structure**, **stateful widgets**, and **local persistence** without relying on any backend or cloud services.

## Preview

  <img width="1189" height="976" alt="image" src="https://github.com/user-attachments/assets/bff7af01-34b9-4205-8fd0-eebd1478401a" />

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
