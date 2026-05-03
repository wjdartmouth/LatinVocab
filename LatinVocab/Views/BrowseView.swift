import SwiftUI
import SwiftData

struct BrowseView: View {
    @Environment(\.modelContext) private var context
    @Query private var words: [Word]
    @State private var viewModel = BrowseViewModel()
    @State private var showingAddWord = false
    @State private var wordToEdit: Word?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.filterOptions, id: \.self) { option in
                            FilterChip(
                                label: option,
                                isSelected: viewModel.selectedPartOfSpeech == option
                            ) {
                                viewModel.selectedPartOfSpeech = option
                            }
                        }
                        Toggle("Mastered", isOn: $viewModel.showMasteredOnly)
                            .toggleStyle(.button)
                            .buttonStyle(.bordered)
                            .tint(.green)
                            .font(.caption)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.gray).opacity(0.1))

                Divider()

                let filtered = viewModel.filteredWords(words)

                if filtered.isEmpty {
                    ContentUnavailableView(
                        "No Words Found",
                        systemImage: "text.magnifyingglass",
                        description: Text("Try adjusting your search or filters.")
                    )
                } else {
                    List {
                        ForEach(filtered) { word in
                            WordRowView(word: word) {
                                viewModel.toggleMastered(word, context: context)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { wordToEdit = word }
                        }
                        .onDelete { offsets in
                            viewModel.deleteWords(words, offsets: offsets, context: context)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Latin Words")
            .searchable(text: $viewModel.searchText, prompt: "Search latin or english…")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddWord = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddWord) {
                AddWordView()
            }
            .sheet(item: $wordToEdit) { word in
                AddWordView(wordToEdit: word)
            }
        }
    }
}

struct WordRowView: View {
    let word: Word
    let onToggleMastered: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(word.latin)
                        .font(.headline)
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(word.english)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 6) {
                    Text(word.partOfSpeech)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.indigo.opacity(0.15))
                        .foregroundStyle(Color.indigo)
                        .clipShape(Capsule())
                    if word.timesQuizzed > 0 {
                        Text("\(Int(word.accuracy * 100))% accuracy")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
            Button(action: onToggleMastered) {
                Image(systemName: word.isMastered ? "star.fill" : "star")
                    .foregroundStyle(word.isMastered ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.indigo : Color(.gray).opacity(0.12))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
