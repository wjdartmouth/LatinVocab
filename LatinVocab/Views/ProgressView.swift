import SwiftUI
import SwiftData

struct ProgressView: View {
    @Query private var words: [Word]
    @Query private var sessions: [QuizSession]
    @State private var viewModel = ProgressViewModel()

    var body: some View {
        NavigationStack {
            List {
                // Overview stats
                Section {
                    HStack(spacing: 0) {
                        StatTileView(
                            value: "\(viewModel.totalWords(words))",
                            label: "Total Words",
                            icon: "book.closed",
                            color: .indigo
                        )
                        Divider()
                        StatTileView(
                            value: "\(viewModel.masteredCount(words))",
                            label: "Mastered",
                            icon: "star.fill",
                            color: .yellow
                        )
                        Divider()
                        StatTileView(
                            value: "\(viewModel.streakDays(sessions))d",
                            label: "Streak",
                            icon: "flame.fill",
                            color: .orange
                        )
                    }
                    .frame(maxWidth: .infinity)
                }
                .listRowInsets(.init())

                // Mastery progress
                Section("Mastery") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Overall progress")
                                .font(.subheadline)
                            Spacer()
                            Text(String(format: "%.0f%%", viewModel.masteredPercentage(words)))
                                .font(.subheadline.bold())
                                .foregroundStyle(.indigo)
                        }
                        ProgressView(value: viewModel.masteredPercentage(words), total: 100)
                            .tint(.indigo)
                    }
                    .padding(.vertical, 4)
                }

                // Recent sessions
                let recent = viewModel.recentSessions(sessions)
                if !recent.isEmpty {
                    Section("Recent Sessions") {
                        ForEach(recent) { session in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(session.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.subheadline)
                                    Text("\(session.score)/\(session.totalAsked) correct")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(String(format: "%.0f%%", session.percentage))
                                    .font(.headline)
                                    .foregroundStyle(session.percentage >= 80 ? .green : session.percentage >= 50 ? .orange : .red)
                            }
                        }
                    }
                }

                // Hardest words
                let hard = viewModel.hardestWords(words)
                if !hard.isEmpty {
                    Section("Needs Work") {
                        ForEach(hard) { word in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(word.latin)
                                        .font(.subheadline.bold())
                                    Text(word.english)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(String(format: "%.0f%%", word.accuracy * 100))
                                    .font(.subheadline)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Progress")
        }
    }
}

struct StatTileView: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title2.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}
