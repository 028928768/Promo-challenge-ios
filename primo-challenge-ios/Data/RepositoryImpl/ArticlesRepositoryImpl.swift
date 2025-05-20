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

    func fetchArticles() async -> [Article] {
        do {
            let localArticles = try await local.loadArticles()
            
            // check for existing data
            if !localArticles.isEmpty {
                // Return local first, then refresh in background
                Task {
                    do {
                        let fetched = await remote.fetchArticles()
                        try await local.saveArticles(fetched)
                    } catch {
                        print("Failed to save fetched articles: \(error)")
                    }
                } // Task
                return localArticles
            } else {
                let fetched = await remote.fetchArticles()
                do {
                    try await local.saveArticles(fetched)
                } catch {
                    print("Failed to save new articles: \(error)")
                }
                return fetched
            }
        } catch {
            print("Failed to load from local database: \(error)")
            return []
        }
    }
}
