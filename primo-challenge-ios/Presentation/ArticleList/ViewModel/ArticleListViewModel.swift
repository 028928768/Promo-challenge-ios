//
//  ArticleListViewModel.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation

@MainActor
final class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var selectedArticle: Article?
    @Published var state: ViewState<[Article]> = .idle

    private let useCase: FetchArticlesUseCase
    
    init(useCase: FetchArticlesUseCase? = nil) {
        self.useCase = useCase ?? FetchArticlesUseCaseImpl(
            repository: ArticlesRepositoryImpl(remote: ArticleFeedServiceImpl(), local: ArticleCoreDataServiceImpl()))
    }
    
    func loadArticles() async {
        state = .loading
        
        let result = await useCase.execute()
        switch result {
        case .success(let success):
            self.articles = success
            self.state = .success(articles)
        case .failure(let error):
            self.state = .failed(error)
        }
    }
}

enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case failed(Error)
}
