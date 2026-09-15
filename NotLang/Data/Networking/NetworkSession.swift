//
//  NetworkSession.swift
//  NotLang
//
//  Created by Amier Davis on 2/27/26.
//

import Foundation

public protocol NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession { }
