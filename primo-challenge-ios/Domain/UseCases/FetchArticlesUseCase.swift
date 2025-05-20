//
//  FetchArticlesUseCase.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation

protocol FetchArticlesUseCase {
    func execute() async -> [Article]
}

final class FetchArticlesUseCaseImpl: FetchArticlesUseCase {
    private let repository: ArticlesRepository
    
    init(repository: ArticlesRepository) {
        self.repository = repository
    }
    
    func execute() async -> [Article] {
        // fetch articles from repository
        await repository.fetchArticles()
    }
}
