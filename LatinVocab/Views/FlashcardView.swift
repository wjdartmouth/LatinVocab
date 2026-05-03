import SwiftUI

struct FlashcardView: View {
    let prompt: String
    let answer: String
    let partOfSpeech: String
    let isFlipped: Bool
    let onFlip: () -> Void

    var body: some View {
        ZStack {
            // Front
            CardFace(
                text: prompt,
                label: "Latin",
                partOfSpeech: partOfSpeech,
                color: .indigo
            )
            .opacity(isFlipped ? 0 : 1)
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Back
            CardFace(
                text: answer,
                label: "English",
                partOfSpeech: partOfSpeech,
                color: .teal
            )
            .opacity(isFlipped ? 1 : 0)
            .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .onTapGesture(perform: onFlip)
        .accessibilityLabel(isFlipped ? "Answer: \(answer)" : "Question: \(prompt). Tap to reveal answer.")
    }
}

struct CardFace: View {
    let text: String
    let label: String
    let partOfSpeech: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Text(label.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(color.opacity(0.7))
                .tracking(1.5)

            Text(text)
                .font(.system(size: 36, weight: .bold, design: .serif))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .foregroundStyle(.primary)

            Text(partOfSpeech)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(color.opacity(0.12))
                .foregroundStyle(color)
                .clipShape(Capsule())
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(color.opacity(0.2), lineWidth: 1)
        )
    }
}
