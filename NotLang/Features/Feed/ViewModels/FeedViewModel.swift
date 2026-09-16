//
//  FeedViewModel.swift
//  NotLang
//
//  Created by Amier Davis on 1/15/26.
//

import Foundation
import Observation
import SwiftData

/// Handles data to be presented to the feed.
@Observable
class FeedViewModel {
    var isLoading: Bool = false
    var posts: [LangPost] = []

    var countdownText: String = "00:00:00"
    private var timer: Timer?
    var timeUntilNextDrop: String {
        let now = Date()

        var utcCalendar = Calendar(identifier: .gregorian)
        utcCalendar.timeZone = TimeZone(abbreviation: "UTC")!

        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        components.second = 0

        guard
            let nextDropDate = utcCalendar.nextDate(
                after: now,
                matching: components,
                matchingPolicy: .nextTime
            )
        else {
            return "00:00:00"
        }

        let diff = utcCalendar.dateComponents(
            [.hour, .minute, .second],
            from: now,
            to: nextDropDate
        )

        return String(
            format: "%02d:%02d:%02d",
            diff.hour ?? 0,
            diff.minute ?? 0,
            diff.second ?? 0
        )
    }

    init() {
        startCountdown()
    }

    func fetchPosts() async {
        let apiService = APIService()
        isLoading = true
        try? await Task.sleep(for: .seconds(1))
        let newPosts = try? await apiService.fetchPosts()
        assert(newPosts != nil, "fetchPosts failed in FeedViewModel")

        self.posts = newPosts ?? [LangPost]()
        isLoading = false
    }

    func startCountdown() {
        self.countdownText = timeUntilNextDrop

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self] _ in
            guard let self = self else { return }
            self.countdownText = self.timeUntilNextDrop
        }
    }

    deinit {
        timer?.invalidate()
    }
}
