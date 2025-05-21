//
//  ArticleFeedServiceImplTests.swift
//  primo-challenge-iosTests
//
//  Created by Simon SIwell on 21/5/2568 BE.
//

import XCTest
@testable import primo_challenge_ios

final class ArticleFeedServiceImplTests: XCTestCase {
    
    var service: ArticleFeedServiceImpl!
    
    override func setUp() {
        super.setUp()
        service = ArticleFeedServiceImpl()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func test_fetchArticles_returnnonEmptyArray() async throws {
        let articles = try await service.fetchArticles()
        
        XCTAssertFalse(articles.isEmpty, "Expected articles array so it should not be empty!")
    }
    
    func test_fetchArticles_paresTitles() async throws {
        let articles = try await service.fetchArticles()
        
        // Check if parsing XML to articleDO logic is valid
        for article in articles {
            XCTAssertFalse(article.title.isEmpty, "Article parse title failed! it should have a title")
        }
    }
    
    func test_fetchArticles_withBadURL_throwsBadURLError() async {
        let service = ArticleFeedServiceImpl(feedURL: nil)
        
        do {
            _ = try await service.fetchArticles()
            XCTFail("Expected to throw badURL, but it did not throw")
        } catch let error as URLError {
            // check if the throw error is badURL
            XCTAssertEqual(error.code, .badURL)
        } catch {
            XCTFail("Unexpecte error: \(error)")
        }
    }
    
    func test_imageExtraction_fromHTMLContent() async throws {
        let mockXML = """
        <rss>
            <channel>
                <item>
                    <title>Sample Title</title>
                    <description><![CDATA[<p>This is a Simon test checking image extraction logic</p>]]></description>
                    <content:encoded><![CDATA[
                        <figure>
                            <img src="https://example.com/image1.png" />
                        </figure>
                        <figure>
                            <img src="https://example.com/image2.jpg" />
                        </figure>
                    ]]></content:encoded>
                    <category>Swift</category>
                    <category>iOS</category>
                    <link>https://medium.com/@primoapp/sample-post</link>
                    <pubDate>Mon, 20 May 2024 10:00:00 GMT</pubDate>
                </item>
            </channel>
        </rss>
        """

        let data = Data(mockXML.utf8)

        // Inject a dummy URL but bypass the network by setting parser data directly
        let service = ArticleFeedServiceImpl(feedURL: nil)
        let parser = XMLParser(data: data)
        parser.delegate = service

        let parseSuccess = parser.parse()
        XCTAssertTrue(parseSuccess, "Parser should succeed")

        let articles = service.getParsedArticles() // Access the internal article list

        XCTAssertEqual(articles.count, 1)
        // assume by using first fetched article
        let article = articles.first!
        
        // Check image URL extraction -> 2 mock up images should be extracted here.
        XCTAssertEqual(article.imageUrls.count, 2)
        XCTAssertEqual(article.imageUrls[0], "https://example.com/image1.png")
        XCTAssertEqual(article.imageUrls[1], "https://example.com/image2.jpg")
    }
    
    func testInvalidXMLFormatted_throwError() async {
        let invalidXML = "<rss><item><title>Oops"
        let mockSession = MockURLSession(data: invalidXML.data(using: .utf8), error: nil)
        let service = ArticleFeedServiceImpl(session: mockSession)
        
        do {
            _ = try await service.fetchArticles()
            XCTFail("invalid XML should fail instead of be parsed successfully")
        } catch {
            // XMLParser doesn’t throw but won't parse items
            XCTAssertTrue(service.getParsedArticles().isEmpty, "Expected no articles for invalid XML")
        }
    }
    
    func testNoIntenetConnection_throwsURLError() async {
        // assign nil into the mock session so there is no internet
        let mockSession = MockURLSession(data: nil, error: URLError(.notConnectedToInternet))
        let service = ArticleFeedServiceImpl(session: mockSession)

        do {
            _ = try await service.fetchArticles()
            XCTFail("Expected to throw for network failure")
        } catch let error as URLError {
            // since the error is to notConnectedToInternet
            XCTAssertEqual(error.code, .notConnectedToInternet)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testEmptyFeed_returnsEmptyArticles() async throws {
        // mock up empty HTML content
        let emptyFeed = """
        <rss><channel></channel></rss>
        """
        
        // normal session
        let mockSession = MockURLSession(data: emptyFeed.data(using: .utf8), error: nil)
        let service = ArticleFeedServiceImpl(session: mockSession)

        let articles = try await service.fetchArticles()
        // empty feed so it should not be able to extracted any articles
        XCTAssertTrue(articles.isEmpty, "Expected no articles in empty feed")
    }
    
    // Test offline support logic
    func test_fetchArticles_returnsCachedThenRemote() async throws {
        let remoteService = MockArticleFeedService()
        let localService = MockArticleCoreDataService()
        let repository = ArticlesRepositoryImpl(remote: remoteService, local: localService)

        let result = try await repository.fetchArticles()
        
        // checking by using counting of save and load into local
        // The fetched articles are the one from remote (2 mocks articles)
        // local services load and save were called once
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(localService.loadCallCount, 1)
        XCTAssertEqual(localService.saveCallCount, 1)
    }
}

// Mockup URL session - testing network layer
final class MockURLSession: NetworkSession {
    let mockData: Data?
    let mockError: Error?
    
    init(data: Data?, error: Error?) {
        self.mockData = data
        self.mockError = error
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        return (mockData ?? Data(), URLResponse())
    }
}

// Mockup remote service
final class MockArticleFeedService: ArticleFeedService {
    func fetchArticles() async -> [Article] {
        return [Article.mock() , Article.mock()]
    }
}

// Mockup local service
final class MockArticleCoreDataService: ArticleCoreDataService {
    var loadCallCount = 0
    var saveCallCount = 0

    func loadArticles() -> [Article] {
        loadCallCount += 1
        return []
    }

    func saveArticles(_ articles: [Article]) {
        saveCallCount += 1
    }
}

