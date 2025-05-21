//
//  Article.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation

struct Article: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let description: String
    let content: String
    let publishedDate: Date
    let categories: [String]
    let imageUrls: [String]
}

extension Article {
    static let preview = Article(
        id: "preview-id",
        title: "Preview Article Title",
        description: "Short summary for preview.",
        content: "Full content here.",
        publishedDate: Date(),
        categories: ["Swift", "iOS"],
        imageUrls: ["https://cdn-images-1.medium.com/max/1024/1*oC2AS8oWM7kT4OOdpqNUBw.jpeg", "https://cdn-images-1.medium.com/max/759/1*4lrRo_Li6DoNM484baR9sw.jpeg"]
    )
    
    static func mock(
        id: UUID = UUID(),
        title: String = "Mock Title",
        description: String = "This is a mock description.",
        link: String = "https://example.com",
        pubDate: Date = Date(),
        categories: [String] = ["Swift", "iOS"],
        imageUrls: [String] = ["https://example.com/image.jpg"]
    ) -> Article {
        return Article(
            id: id.uuidString,
            title: title,
            description: description,
            content: link,
            publishedDate: pubDate,
            categories: categories,
            imageUrls: imageUrls
        )
    }
    
    static let mockArticle1 = Article(
        id: "11111111-1111-1111-1111-111111111111",
        title: "Mock Article One",
        description: "Description for mock article one.",
        content: "Content for mock article one.",
        publishedDate: Date(timeIntervalSince1970: 1_000_000),
        categories: ["News", "Tech"],
        imageUrls: ["https://example.com/image1.jpg"]
    )
    
    static let mockArticle2 = Article(
        id: "22222222-2222-2222-2222-222222222222",
        title: "Mock Article Two",
        description: "Description for mock article two.",
        content: "Content for mock article two.",
        publishedDate: Date(timeIntervalSince1970: 2_000_000),
        categories: ["Sports"],
        imageUrls: ["https://example.com/image2.jpg"]
    )
}
