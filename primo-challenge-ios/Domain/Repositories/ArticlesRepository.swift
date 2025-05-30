//
//  ArticlesRepository.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation

protocol ArticlesRepository {
    func fetchArticles() async throws -> [Article]
}
