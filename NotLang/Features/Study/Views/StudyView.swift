import SwiftData
import SwiftUI

struct StudyView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = StudyViewModel()

    // Session state
    @State private var currentIndex: Int = 0
    @State private var isFlipped: Bool = false
    @State private var showControls: Bool = false

    // Fetch only chunks that are due now or earlier
    @Query private var dueChunks: [SavedChunk]

    init() {
        let now = Date()
        _dueChunks = Query(
            filter: #Predicate<SavedChunk> { $0.nextReviewDate <= now },
            sort: [SortDescriptor(\SavedChunk.nextReviewDate)]
        )
    }

    var body: some View {
        VStack(spacing: 24) {
            if dueChunks.isEmpty {
                EmptyStateView(
                    title: "No cards due today.",
                    subtitle:
                        "Great job! Come back tomorrow or save more chunks to study."
                )
            } else {
                Text(
                    "\(min(currentIndex + 1, dueChunks.count)) of \(dueChunks.count)"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)

                cardView
                    .frame(height: 260)
                    .onTapGesture(perform: handleFlip)

                if showControls, let chunk = currentChunk {
                    srsControls(for: chunk)
                        .transition(
                            .move(edge: .bottom).combined(with: .opacity)
                        )
                }

                Spacer(minLength: 0)
            }
        }
        .padding()
        .navigationTitle("Study")
        .animation(
            .spring(response: 0.35, dampingFraction: 0.8),
            value: isFlipped
        )
        .animation(
            .spring(response: 0.35, dampingFraction: 0.8),
            value: showControls
        )
        .onChange(of: dueChunks) { _, _ in
            clampIndex()
        }
    }

    private var currentChunk: SavedChunk? {
        guard !dueChunks.isEmpty else { return nil }
        let safeIndex = max(0, min(currentIndex, dueChunks.count - 1))
        return dueChunks[safeIndex]
    }

    private var cardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(isFlipped ? Color.blue : Color.gray.opacity(0.2))
                .shadow(radius: 3)

            VStack {
                if let chunk = currentChunk {
                    Text(isFlipped ? chunk.translation : chunk.text)
                        .font(.largeTitle)
                        .foregroundStyle(isFlipped ? .white : .primary)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        .padding()
                        .scaleEffect(x: isFlipped ? -1 : 1)
                }
            }
            .padding()
        }
        .rotation3DEffect(
            Angle(degrees: isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(
            .spring(response: 0.45, dampingFraction: 0.75),
            value: isFlipped
        )
    }

    private func srsControls(for chunk: SavedChunk) -> some View {
        HStack(spacing: 12) {
            Button("Again") {
                submit(.again, for: chunk)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)

            Button("Hard") {
                submit(.hard, for: chunk)
            }
            .buttonStyle(.bordered)
            .tint(.orange)

            Button("Good") {
                submit(.good, for: chunk)
            }
            .buttonStyle(.bordered)
            .tint(.blue)

            Button("Easy") {
                submit(.easy, for: chunk)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .font(.headline)
    }

    private func handleFlip() {
        guard currentChunk != nil else { return }
        withAnimation {
            isFlipped.toggle()
            showControls = isFlipped
        }
    }

    private func submit(
        _ difficulty: StudyViewModel.Difficulty,
        for chunk: SavedChunk
    ) {
        // Perform review update via the view model
        viewModel.review(chunk, difficulty: difficulty, context: modelContext)

        // Ensure "Again" keeps the card in the due list and shows it again immediately.
        if difficulty == .again {
            // Keep the card due now so it remains in the query results for this session
            chunk.nextReviewDate = Date()
            try? modelContext.save()

            // Reset flip state but do NOT advance index so the same card appears again
            withAnimation {
                isFlipped = false
                showControls = false
            }
            // Clamp in case the query changed
            clampIndex()
            return
        }

        // For other difficulties, advance to the next card.
        advance()
    }

    private func advance() {
        withAnimation {
            isFlipped = false
            showControls = false
        }
        // If we were at the end, wrap to 0; also clamp against updated results
        if currentIndex >= dueChunks.count - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        clampIndex()
    }

    private func clampIndex() {
        if dueChunks.isEmpty {
            currentIndex = 0
        } else {
            currentIndex = min(currentIndex, max(0, dueChunks.count - 1))
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: SavedChunk.self,
            configurations: config
        )

        // Seed some due and not-due examples
        let now = Date()
        let past = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let future = Calendar.current.date(byAdding: .day, value: 5, to: now)!

        let due1 = SavedChunk(text: "Bonjour", translation: "Hello")
        due1.nextReviewDate = past

        let due2 = SavedChunk(text: "Pomme de terre", translation: "Potato")
        due2.nextReviewDate = now

        let notDue = SavedChunk(text: "Bibliothèque", translation: "Library")
        notDue.nextReviewDate = future

        container.mainContext.insert(due1)
        container.mainContext.insert(due2)
        container.mainContext.insert(notDue)

        return NavigationStack {
            StudyView()
        }
        .modelContainer(container)
    } catch {
        return Text(
            "Failed to create preview container: \(error.localizedDescription)"
        )
    }
}
