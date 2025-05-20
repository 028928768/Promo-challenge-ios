//
//  Article.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation

struct Article: Identifiable {
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
}

