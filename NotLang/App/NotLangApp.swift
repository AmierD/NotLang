//
//  NotLangApp.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import SwiftUI
import SwiftData

@main
struct NotLangApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedChunk.self)
    }
}
