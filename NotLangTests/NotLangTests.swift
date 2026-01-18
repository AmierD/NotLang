//
//  NotLangTests.swift
//  NotLangTests
//
//  Created by Amier Davis on 1/12/26.
//

import Testing
@testable import NotLang

struct NotLangTests {

    @Test("Validate that Mock JSON LangPost decoding produces a valid post")
    func test_mockJSONLangPost_successfullyDecodesToLangPost() async throws {
        let post = await LangPost.mockJSONLangPost()
        
        #expect(post.author != "Error")
        #expect(post.topic != "N/A")
        #expect(!post.content.isEmpty)
    }

}
