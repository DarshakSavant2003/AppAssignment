# Flutter News App

A Flutter-based news application that fetches data from an open-source API (`NewsAPI`) and displays it in a user-friendly interface. The app includes features like vertical and horizontal ListViews, pull-to-refresh functionality, and a splash screen.

## Features

### 1. **List View with Object Cards**
- Fetches news articles from the [NewsAPI](https://newsapi.org/) and displays them in a vertical `ListView`.
- Each object card includes:
  - News title
  - Description
  - Source
  - Published date
  - Thumbnail image (if available)
  
### 2. **Pull-to-Refresh**
- Implements a swipe-down refresh indicator to update the news feed.
- Displays a popup notification confirming the update once the refresh is complete.

### 3. **Horizontal List View 
- Displays categories in a horizontal `ListView` to filter news articles by category.

### 4. **Splash Screen**
- Features a visually appealing splash screen displayed at app startup.

## Requirements
### **Setup**
- Flutter SDK
- Dart programming language
- VS Code for development

### **Dependencies**
This project uses the following dependencies:
- `get` - For state management and routing.
- `http` - For fetching data from the API.
- `url_launcher` - To open article links in an external browser.

### **API**
- **NewsAPI**: Used to fetch news articles.
  - [Sign up for an API key](https://newsapi.org/) to use the app.

## How to Run the App
1. Clone the repository:
   ```bash
   git clone https://github.com/DarshakSavant2003/AppAssignment.git
   cd FlutterApp/newsapp

