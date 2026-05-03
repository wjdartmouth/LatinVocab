import SwiftUI
import SwiftData

@main
struct LatinVocabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(PersistenceController.shared.container)
    }
}
