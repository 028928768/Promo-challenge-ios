//
//  NetworkSession.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 21/5/2568 BE.
//

import Foundation

// MARK: - use for creating mockSession instead of subclass and overiding URLSession directly
protocol NetworkSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}
