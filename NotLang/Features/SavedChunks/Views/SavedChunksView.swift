//
//  SavedChunksView.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

import SwiftData
import SwiftUI

struct SavedChunksView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \SavedChunk.text) var savedChunks: [SavedChunk]

    private var groupedChunks: [(key: String, values: [SavedChunk])] {
        let grouped = Dictionary(grouping: savedChunks) { chunk in
            String(chunk.text.prefix(1)).uppercased()
        }
        return grouped.map { (key: $0.key, values: $0.value) }
            .sorted { $0.key < $1.key }
    }

    private var alphabet: [String] {
        groupedChunks.map { $0.key }
    }

    var body: some View {
        NavigationStack {
            if savedChunks.isEmpty {
                EmptyStateView(
                    title: "No saved chunks",
                    subtitle: "Double tap a chunk in your feed to save it."
                )
                .navigationTitle("Saved Chunks")
            } else {
                ScrollViewReader { proxy in
                    ZStack(alignment: .trailing) {
                        List {
                            ForEach(groupedChunks, id: \.key) { section in
                                Section(
                                    header: Text(section.key)
                                        .id(section.key)
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                ) {
                                    ForEach(section.values) { chunk in
                                        SavedChunkView(chunk: chunk)
                                            .listRowSeparator(.hidden)
                                    }
                                    .onDelete { offsets in
                                        deleteFromSection(
                                            offsets,
                                            section: section
                                        )
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)

                        alphabetIndexBar(proxy: proxy)
                    }
                    .navigationTitle("Saved Chunks")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(destination: StudyView()) {
                                Label("Study", systemImage: "graduationcap")
                            }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            EditButton()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private func alphabetIndexBar(proxy: ScrollViewProxy) -> some View {
        VStack(spacing: 0) {
            ForEach(alphabet, id: \.self) { letter in
                Text(letter)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(width: 25, height: 18)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(letter, anchor: .top)
                        }
                    }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let touchPoint = value.location.y
                    let letterHeight: CGFloat = 18
                    let index = Int(touchPoint / letterHeight)

                    if index >= 0 && index < alphabet.count {
                        let letter = alphabet[index]
                        proxy.scrollTo(letter, anchor: .top)
                    }
                }
        )
    }

    // MARK: - Logic

    func deleteFromSection(
        _ offsets: IndexSet,
        section: (key: String, values: [SavedChunk])
    ) {
        for index in offsets {
            let chunk = section.values[index]
            modelContext.delete(chunk)
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

        let mocks = [
            SavedChunk(text: "Bonjour", translation: "Hello"),
            SavedChunk(text: "Bibliothèque", translation: "Library"),
            SavedChunk(text: "Pomme de terre", translation: "Potato"),
        ]

        return Group {
            SavedChunksView()
                .modelContainer(container)
                .environment(SavedChunksViewModel())
            Button("Add") {
                for chunk in mocks {
                    container.mainContext.insert(chunk)
                }
            }
        }
    } catch {
        return Text(
            "Failed to create preview container: \(error.localizedDescription)"
        )
    }
}
