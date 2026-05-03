# LatinVocab

A native iOS app for building Latin vocabulary through flashcard quizzes, word browsing, and progress tracking.

Built with SwiftUI and SwiftData. Requires iOS 17+ and Xcode 15+.

---

## Features

**Browse** — Search and filter your full word list by part of speech or mastery status. Tap any word to edit it, swipe to delete, or star it to mark it as mastered.

**Quiz** — Flip through flashcards with a 3D card animation. Choose Latin → English or English → Latin direction. After each card is revealed, mark it as *Got it* or *Missed*. Words you answer correctly 80%+ of the time (across at least 3 attempts) are automatically marked mastered and removed from the quiz pool.

**Progress** — See your total word count, mastered count, current study streak, recent session scores, and a "Needs Work" list of your least accurate words.

**Add Custom Words** — Add any Latin word with its English translation, part of speech, and optional notes.

---

## Getting Started

```bash
# 1. Unzip the project
unzip LatinVocab.zip

# 2. Open in Xcode
open LatinVocab/LatinVocab.xcodeproj
```

Select an iPhone simulator (iOS 17+) and press **Run** (⌘R).

The app ships with 25 seed words covering common nouns, verbs, adjectives, and adverbs so it's immediately usable out of the box.

---

## Running on a Real Device

1. In Xcode, select the **LatinVocab** target
2. Under **Signing & Capabilities**, set your **Team** and change the **Bundle Identifier** to something unique (e.g. `com.yourname.latinvocab`)
3. Connect your iPhone and select it as the run destination

---

## Project Structure

```
LatinVocab/
├── LatinVocab.xcodeproj/
├── LatinVocab/
│   ├── LatinVocabApp.swift       # App entry point, ModelContainer setup
│   ├── ContentView.swift         # Root tab bar
│   ├── Models/
│   │   ├── Word.swift            # @Model: latin, english, POS, mastery, accuracy
│   │   └── QuizSession.swift     # @Model: date, score, total asked
│   ├── ViewModels/
│   │   ├── BrowseViewModel.swift # Search, filter, delete, toggle mastered
│   │   ├── QuizViewModel.swift   # Session logic, card flip, scoring
│   │   ├── ProgressViewModel.swift # Stats aggregation, streak calculation
│   │   └── AddWordViewModel.swift  # Form validation and save/update
│   ├── Views/
│   │   ├── BrowseView.swift
│   │   ├── AddWordView.swift
│   │   ├── QuizView.swift
│   │   ├── ProgressView.swift
│   │   └── FlashcardView.swift   # 3D flip card animation
│   └── Services/
│       └── PersistenceController.swift  # SwiftData stack + seed data
└── LatinVocabTests/
    └── LatinVocabTests.swift
```

---

## Architecture

The app follows **MVVM** throughout. Views hold no business logic — all state and data operations live in `@Observable` ViewModels. SwiftData models are passed into ViewModels via `ModelContext`, keeping persistence concerns out of the UI layer.

---

## Requirements

| | |
|---|---|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |
| Dependencies | None (no third-party packages) |

---

## License

MIT
