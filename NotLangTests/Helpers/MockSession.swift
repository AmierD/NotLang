//
//  MockSession.swift
//  NotLang
//
//  Created by Amier Davis on 2/27/26.
//

import NotLang
import Foundation

struct MockSession: NetworkSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error { throw error }
        
        return (data ?? Data(), response ?? URLResponse())
    }
}
