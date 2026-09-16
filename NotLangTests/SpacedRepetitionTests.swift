//
//  SpacedRepetitionTests.swift
//  NotLang
//
//  Created by Amier Davis on 9/15/26.
//

import Foundation
import Testing

@testable import NotLang

struct SpacedRepetitionTests {
    @Test func nextReviewDateIsCorrectInterval() {
        let now = Date()
        let schedule = SpacedRepetitionScheduler.schedule(
            interval: 0,
            repetition: 0,
            easeFactor: 2.5,
            difficulty: .easy,
            from: now
        )
        
        let expectedDate = Calendar.current.date(byAdding: .day, value: schedule.interval, to: now)
        #expect(schedule.nextReviewDate == expectedDate)
    }
    
    @Test func hardIntervalLessThanGoodInterval() {
        let interval = 0
        let repetition = 0
        let easeFactor = 2.5
        let now = Date()
        
        let goodSchedule = SpacedRepetitionScheduler.schedule(
            interval: interval,
            repetition: repetition,
            easeFactor: easeFactor,
            difficulty: .good,
            from: now
        )
        
        let hardSchedule = SpacedRepetitionScheduler.schedule(
            interval: interval,
            repetition: repetition,
            easeFactor: easeFactor,
            difficulty: .hard,
            from: now
        )

        #expect(hardSchedule.interval < goodSchedule.interval)

    }
}
