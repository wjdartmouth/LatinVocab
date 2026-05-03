import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "books.vertical")
                }

            QuizView()
                .tabItem {
                    Label("Quiz", systemImage: "rectangle.on.rectangle")
                }

            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
        }
        .tint(.indigo)
    }
}
