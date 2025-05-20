//
//  ArticleDetailView.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(article.title)
                    .font(.title)
                Text(article.content)
            }
            .padding()
        }
    }
}

//#Preview {
//    ArticleDetailView()
//}
