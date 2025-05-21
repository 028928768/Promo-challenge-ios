//
//  FetchArticlesUseCase.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation

protocol FetchArticlesUseCase {
    func execute() async -> Result<[Article], Error>
}

final class FetchArticlesUseCaseImpl: FetchArticlesUseCase {
    private let repository: ArticlesRepository
    
    init(repository: ArticlesRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<[Article], Error> {
        do {
            let articles = try await repository.fetchArticles()
            return .success(articles)
        } catch {
            return .failure(error)
        }

    }
}
