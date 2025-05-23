//
//  ArticlesRepositoryImpl.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation
import CoreData

final class ArticlesRepositoryImpl: ArticlesRepository {
    let remote: ArticleFeedService
    let local: ArticleCoreDataService

    init(remote: ArticleFeedService, local: ArticleCoreDataService) {
        self.remote = remote
        self.local = local
    }

    func fetchArticles() async throws -> [Article] {
        let localArticles = try await local.loadArticles()
            
            // check for existing data
            if !localArticles.isEmpty {
                // Return local first, then refresh in background
                Task {
                    do {
                        let fetched = try await remote.fetchArticles()
                        try await local.saveArticles(fetched)
                    } catch {
                        print("Failed to save fetched articles: \(error)")
                    }
                } // Task
                return localArticles
            } else {
                let fetched = try await remote.fetchArticles()
                try await local.saveArticles(fetched)
                return fetched
            }

        
    }
}
