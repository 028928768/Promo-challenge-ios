//
//  ArticleCoreDataService.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation
import CoreData

protocol ArticleCoreDataService {
    func saveArticles(_ articles: [Article]) async throws
    func loadArticles() async throws -> [Article]
}

final class ArticleCoreDataServiceImpl: ArticleCoreDataService {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    init(container: NSPersistentContainer? = nil) {
        if let container = container {
            // Test or dependency-injected container – assume it's already loaded
            self.container = container
        } else {
            // No container provided – create and load the default one
            self.container = NSPersistentContainer(name: "ArticlesDatabase")
            self.container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Core Data failed to load: \(error.localizedDescription)")
                }
            }
        }
        self.context = self.container.viewContext
    }

    func saveArticles(_ articles: [Article]) async throws {
        // removed existing articles first
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        let existingArticles = try context.fetch(fetchRequest)
        for article in existingArticles {
            context.delete(article)
        }
        
        // save new articles
        for article in articles {
            let cdArticleEntity = ArticleEntity(context: context)
            cdArticleEntity.id = article.id
            cdArticleEntity.title = article.title
            cdArticleEntity.articleDescription = article.description
            cdArticleEntity.content = article.content
            cdArticleEntity.publishedDate = article.publishedDate
            cdArticleEntity.categories = article.categories as NSArray
            cdArticleEntity.imageUrls = article.imageUrls as NSArray
        }
        
        try context.save()
    }
    
    func loadArticles() async throws -> [Article] {
        // load articles from coreData
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        
        let results = try context.fetch(request)
        return results.map { coreData in
            Article(
                id: coreData.id ?? UUID().uuidString,
                title: coreData.title ?? "",
                description: coreData.articleDescription ?? "",
                content: coreData.content ?? "",
                publishedDate: coreData.publishedDate ?? Date(),
                categories: coreData.categories as? [String] ?? [],
                imageUrls: coreData.imageUrls as? [String] ?? []
            )
        }
        
     
    }
}
