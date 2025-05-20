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

