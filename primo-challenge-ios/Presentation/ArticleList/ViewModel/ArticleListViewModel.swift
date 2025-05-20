//
//  ArticleListViewModel.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation

final class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var selectedArticle: Article?
    
    private let useCase: FetchArticlesUseCase = FetchArticlesUseCaseImpl(
        repository: ArticlesRepositoryImpl(remote: ArticleFeedServiceImpl(), local: ArticleCoreDataServiceImpl())
    )
    
    func loadArticles() {
        Task {
            let result = await useCase.execute()
            DispatchQueue.main.async {
                // Run on main thread
                self.articles = result
            }
        }
    }
    
    func select(_ article: Article) {
        selectedArticle = article
    }
   
}
