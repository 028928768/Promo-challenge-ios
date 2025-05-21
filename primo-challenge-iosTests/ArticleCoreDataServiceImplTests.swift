//
//  ArticleCoreDataServiceImplTests.swift
//  primo-challenge-iosTests
//
//  Created by Simon SIwell on 21/5/2568 BE.
//

import XCTest
import CoreData
@testable import primo_challenge_ios

final class ArticleCoreDataServiceImplTests: XCTestCase {

    var coreDataService: ArticleCoreDataService!
    var persistentContainer: NSPersistentContainer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let container = NSPersistentContainer(name: "ArticlesDatabase")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        let expectation = expectation(description: "Load persistent store")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error, "Failed to load in-memory store: \(String(describing: error))")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        persistentContainer = container
        coreDataService = ArticleCoreDataServiceImpl(container: container)
    }


    
    override func tearDownWithError() throws {
        coreDataService = nil
        persistentContainer = nil
        try super.tearDownWithError()
    }
    
    func test_SaveAndLoadArticles() async throws {
        let articlesToSave = [Article.mockArticle1, Article.mockArticle2	]
        
        // save
        try await coreDataService.saveArticles(articlesToSave)
        
        // load the articles then check total articles
        let loadedArticles = try await coreDataService.loadArticles()
        XCTAssertEqual(loadedArticles.count, articlesToSave.count)
        
        // check if the save and load do match
        XCTAssertTrue(
            Set(loadedArticles) == Set(articlesToSave)
        )
    }
    
    func testLoadArticlesWhenEmpty() async throws {
        // Load articles without saving anything first
        let loadedArticles = try await coreDataService.loadArticles()
        XCTAssertTrue(loadedArticles.isEmpty)
    }
    
    func testSaveEmptyArticlesArray() async throws {
        // Save empty array should not crash or save anything
        try await coreDataService.saveArticles([])
        let loadedArticles = try await coreDataService.loadArticles()
        XCTAssertTrue(loadedArticles.isEmpty)
    }
    
}
