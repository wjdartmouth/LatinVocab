import SwiftUI
import SwiftData

struct AddWordView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddWordViewModel()

    var wordToEdit: Word?

    var body: some View {
        NavigationStack {
            Form {
                Section("Word") {
                    LabeledContent("Latin") {
                        TextField("e.g. amor", text: $viewModel.latin)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent("English") {
                        TextField("e.g. love", text: $viewModel.english)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Details") {
                    Picker("Part of Speech", selection: $viewModel.partOfSpeech) {
                        ForEach(Word.partsOfSpeech, id: \.self) { pos in
                            Text(pos).tag(pos)
                        }
                    }
                    TextField("Notes (optional)", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle(wordToEdit == nil ? "Add Word" : "Edit Word")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let success = wordToEdit == nil
                            ? viewModel.save(context: context)
                            : viewModel.update(word: wordToEdit!, context: context)
                        if success { dismiss() }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .onAppear {
                if let word = wordToEdit {
                    viewModel.populate(from: word)
                }
            }
        }
    }
}
