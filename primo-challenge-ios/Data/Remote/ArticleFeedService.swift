//
//  ArticleFeedService.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation

protocol ArticleFeedService {
    func fetchArticles() async throws -> [Article]
}
final class ArticleFeedServiceImpl: NSObject, XMLParserDelegate, ArticleFeedService {
    private var currentElement = ""
    
    private var currentTitle = ""
    private var currentLink = ""
    private var currentDescription = ""
    private var currentContent = ""
    private var currentPublishedDate = ""
    private var currentCategories: [String] = []
    
    private var articles: [Article] = []
    private var isInsideItem = false
    
    // MARK: - for mocking and dependencies injection (urlSession) in Tests
    private let feedURL: URL?
    private let session: NetworkSession
    private(set) var parseError: Error?
    
    init(feedURL: URL? = URL(string: "https://medium.com/feed/@primoapp"), session: NetworkSession = URLSession.shared) {
        self.feedURL = feedURL
        self.session = session
    }
    
    func fetchArticles() async throws -> [Article] {
        // MARK: Implement XML parsing from https://medium.com/feed/@primoapp
        
        guard let url = feedURL else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await session.data(from: url)
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        let success = parser.parse()
        
        // check if parsing is error since by default if failed it doesn't throw anything
        if !success || parseError != nil {
            throw parseError ?? NSError(domain: "XMLParsing", code: -1, userInfo: nil)
        }
        return articles
    }
    
    // MARK: XMLParserDelegate
    
    // Using XML parse delegate method to throw error for Tests
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parseError = parseError
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            isInsideItem = true
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentContent = ""
            currentPublishedDate = ""
            currentCategories = []
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard isInsideItem else { return }
        
        switch currentElement {
        case "title": 
            currentTitle += string
        case "link": 
            currentLink += string
        case "description":
            currentDescription += string
        case "pubDate": 
            currentPublishedDate += string
        case "content:encoded":
            currentContent += string
        case "category":
            currentCategories.append(string.trimmingCharacters(in: .whitespacesAndNewlines))
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            
            let date = formatter.date(from: currentPublishedDate) ?? Date()
            let imageUrls = extractAllImageURLs(from: currentContent)
            
            let article = Article(
                id: currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                description: currentDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                content: currentContent.trimmingCharacters(in: .whitespacesAndNewlines),
                publishedDate: date,
                categories:  currentCategories,
                imageUrls: imageUrls)
            
            articles.append(article)
            isInsideItem = false
        }
    }
    
    // Extract image sources from content
    private func extractAllImageURLs(from html: String) -> [String] {
        let pattern = #"<img[^>]+src\s*=\s*['"]([^'"]+)['"]"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return []
        }

        let nsrange = NSRange(html.startIndex..<html.endIndex, in: html)
        let matches = regex.matches(in: html, options: [], range: nsrange)

        return matches.compactMap {
            guard let range = Range($0.range(at: 1), in: html) else { return nil }
            return String(html[range])
        }
    }
    
    // For internal testing -> so it can access private articles
    func getParsedArticles() -> [Article] {
        return articles
    }

}


