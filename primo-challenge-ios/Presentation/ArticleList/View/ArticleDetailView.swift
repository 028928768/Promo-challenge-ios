//
//  ArticleDetailView.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @State private var webViewHeight: CGFloat = 0
    
    var body: some View {
        ScrollView {
            HTMLView(htmlContent: article.content, contentHeight: $webViewHeight)
                .frame(height: webViewHeight)
                .padding()
            
        }
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ArticleDetailView(article: .preview)
}

