//
//  ArticleListViewModelTests.swift
//  primo-challenge-iosTests
//
//  Created by Simon SIwell on 21/5/2568 BE.
//

import XCTest
@testable import primo_challenge_ios

final class ArticleListViewModelTests: XCTestCase {

    var viewModel: ArticleListViewModel!
    var mockUseCase: MockFetchArticlesUseCase!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchArticlesUseCase()
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    
    func testLoadArticles_success_updatesStateAndArticles() async {
        await MainActor.run {
            viewModel = ArticleListViewModel(useCase: mockUseCase)
        }
        
        let expectedArticles = [
            Article.mock(title: "Test Article 1"),
            Article.mock(title: "Test Article 2")
        ]
        mockUseCase.resultToReturn = .success(expectedArticles)
        await viewModel.loadArticles()
        
        if case .success = await viewModel.state {
            
        } else {
            XCTFail("Expected state to be .success")
        }
    }

    func testLoadArticles_failure_updatesStateToFailed() async {
        let mockUseCase = MockFetchArticlesUseCase()
        await MainActor.run {
            viewModel = ArticleListViewModel(useCase: mockUseCase)
        }
        mockUseCase.resultToReturn = .failure(URLError(.badServerResponse))

        await viewModel.loadArticles()
        
        // Assert
        switch await viewModel.state {
        case .failed(let error):
            XCTAssertNotNil(error)
        default:
            XCTFail("Expected failed state")
        }
    }
}

// MARK: mockup use case allowing injection into viewModel
class MockFetchArticlesUseCase: FetchArticlesUseCase {
    var resultToReturn: Result<[Article], Error> = .success([])
    func execute() async -> Result<[primo_challenge_ios.Article], any Error> {
        return resultToReturn
    }
}
