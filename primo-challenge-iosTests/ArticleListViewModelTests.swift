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
        viewModel = ArticleListViewModel(useCase: mockUseCase)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    
    func testLoadArticles_success_updatesStateAndArticles() async {
        let expectedArticles = [
            Article.mock(title: "Test Article 1"),
            Article.mock(title: "Test Article 2")
        ]
        mockUseCase.resultToReturn = .success(expectedArticles)
        viewModel.loadArticles()

        // Assert
        switch viewModel.state {
        case .success(let articles):
            XCTAssertEqual(articles, expectedArticles)
            XCTAssertEqual(viewModel.articles, expectedArticles)
        default:
            XCTFail("Expected success state")
        }
    }

    func testLoadArticles_failure_updatesStateToFailed() async {
        mockUseCase.resultToReturn = .failure(URLError(.badServerResponse))
        
        viewModel.loadArticles()

        // Assert
        switch viewModel.state {
        case .failed(let error):
            XCTAssertNotNil(error)
        default:
            XCTFail("Expected failed state")
        }
        // if failed articles should be empty
        XCTAssertTrue(viewModel.articles.isEmpty)
    }
}

// MARK: mockup use case allowing injection into viewModel
class MockFetchArticlesUseCase: FetchArticlesUseCase {
    var resultToReturn: Result<[Article], Error> = .success([])
    func execute() async -> Result<[primo_challenge_ios.Article], any Error> {
        return resultToReturn
    }
}
