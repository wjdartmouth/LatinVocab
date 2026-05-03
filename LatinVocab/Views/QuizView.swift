import SwiftUI
import SwiftData

struct QuizView: View {
    @Environment(\.modelContext) private var context
    @Query private var words: [Word]
    @State private var viewModel = QuizViewModel()
    @State private var showingSettings = false
    @State private var selectedDirection: QuizDirection = .latinToEnglish

    var quizableWords: [Word] { words.filter { !$0.isMastered } }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isSessionComplete {
                    SessionResultView(
                        score: viewModel.sessionScore,
                        total: viewModel.sessionTotal
                    ) {
                        viewModel.saveSession(context: context)
                        viewModel.startSession(with: quizableWords, direction: selectedDirection)
                    }
                } else if viewModel.shuffledWords.isEmpty {
                    ContentUnavailableView(
                        "No Words to Quiz",
                        systemImage: "rectangle.on.rectangle",
                        description: Text("Add some words in Browse, or unmark mastered words.")
                    )
                } else if let word = viewModel.currentWord {
                    VStack(spacing: 24) {
                        // Progress bar
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(viewModel.currentIndex + 1) of \(viewModel.shuffledWords.count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("Score: \(viewModel.sessionScore)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            ProgressView(value: viewModel.progress)
                                .tint(.indigo)
                        }
                        .padding(.horizontal)

                        // Flashcard
                        FlashcardView(
                            prompt: viewModel.promptText,
                            answer: viewModel.answerText,
                            partOfSpeech: word.partOfSpeech,
                            isFlipped: viewModel.isFlipped,
                            onFlip: viewModel.flipCard
                        )
                        .padding(.horizontal)

                        if !viewModel.isFlipped {
                            Text("Tap card to reveal")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }

                        // Answer buttons
                        if viewModel.isShowingAnswer {
                            HStack(spacing: 16) {
                                Button {
                                    viewModel.markIncorrect(context: context)
                                } label: {
                                    Label("Missed", systemImage: "xmark")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red)

                                Button {
                                    viewModel.markCorrect(context: context)
                                } label: {
                                    Label("Got it", systemImage: "checkmark")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                            }
                            .padding(.horizontal)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }

                        Spacer()
                    }
                    .padding(.top)
                    .animation(.easeInOut(duration: 0.25), value: viewModel.isShowingAnswer)
                }
            }
            .navigationTitle("Quiz")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .onAppear {
                if viewModel.shuffledWords.isEmpty {
                    viewModel.startSession(with: quizableWords, direction: selectedDirection)
                }
            }
            .sheet(isPresented: $showingSettings) {
                QuizSettingsView(direction: $selectedDirection) {
                    viewModel.startSession(with: quizableWords, direction: selectedDirection)
                    showingSettings = false
                }
            }
        }
    }
}

struct SessionResultView: View {
    let score: Int
    let total: Int
    let onRestart: () -> Void

    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(score) / Double(total) * 100
    }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: percentage >= 80 ? "star.fill" : percentage >= 50 ? "hand.thumbsup.fill" : "arrow.clockwise")
                .font(.system(size: 64))
                .foregroundStyle(percentage >= 80 ? .yellow : percentage >= 50 ? .green : .orange)

            VStack(spacing: 8) {
                Text("Session Complete!")
                    .font(.title.bold())
                Text("\(score) / \(total) correct")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text(String(format: "%.0f%%", percentage))
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(percentage >= 80 ? .green : percentage >= 50 ? .orange : .red)
            }

            Spacer()

            Button("Start New Session", action: onRestart)
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .controlSize(.large)
        }
        .padding()
    }
}

struct QuizSettingsView: View {
    @Binding var direction: QuizDirection
    let onStart: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Quiz Direction") {
                    Picker("Direction", selection: $direction) {
                        Text("Latin → English").tag(QuizDirection.latinToEnglish)
                        Text("English → Latin").tag(QuizDirection.englishToLatin)
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Quiz Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start", action: onStart)
                        .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
