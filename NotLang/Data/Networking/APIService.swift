//
//  APIService.swift
//  NotLang
//
//  Created by Amier Davis on 1/31/26.
//

import Foundation

class APIService {
    /// Injected so tests can supply a stub session in place of URLSession.
    private let session: NetworkSession
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    private let baseURL = URL(
        string: "https://twskxofydkyqxgfqhkhs.supabase.co/rest/v1/posts"
    )!
    private let apiKey = "sb_publishable_YC9pQMThFRaSGB7sYsG1lg_oekxEL3N"

    func fetchPosts() async throws -> [LangPost] {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"

        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue(
            "Bearer \(apiKey)",
            forHTTPHeaderField: "Authorization"
        )

        let (data, response) = try await self.session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()

        return try decoder.decode([LangPost].self, from: data)
    }
}
