//
//  APIServiceTests.swift
//  NotLang
//
//  Created by Amier Davis on 2/26/26.
//

import Testing
@testable import NotLang

import Foundation

struct APIServiceTests {
    @Test("Test API service correctly turns JSON into posts", arguments: [
        [LangPost.bakeryOrder, LangPost.cityLove],
        [LangPost]()
    ])
    func fetchPostsSuccess(posts: [LangPost]) async throws {
        let encodedData = try JSONEncoder().encode(posts)
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        let mockSession = MockSession(data: encodedData, response: mockResponse)
        let service = await APIService(session: mockSession)
        
        let fetchedPosts = try await service.fetchPosts()
        #expect(fetchedPosts.count == posts.count)
        #expect(fetchedPosts == posts)
    }
    
    @Test("Test throws error on 401 Unathorized")
    func fetchPostsUnauthorizedError() async throws {
        let posts = await [LangPost.bakeryOrder, LangPost.cityLove]
        
        let encodedData = try JSONEncoder().encode(posts)
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )!
        
        let mockSession = MockSession(data: encodedData, response: mockResponse)
        
        let service = await APIService(session: mockSession)
        await #expect(throws: URLError(.badServerResponse)) {
            try await service.fetchPosts()
        }
    }
}
