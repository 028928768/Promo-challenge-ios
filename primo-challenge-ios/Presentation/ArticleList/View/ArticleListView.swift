//
//  ArticleListView.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI

struct ArticleListView: View {
    @StateObject private var viewModel = ArticleListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                //: Header
                HStack {
                    Text("PRIMO")
                }
                List(viewModel.articles) { article in
                    ArticleCardView(article: article)
                        .onTapGesture {
                            viewModel.select(article)
                        }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            viewModel.loadArticles()
        }
        .sheet(item: $viewModel.selectedArticle) { article in
            ArticleDetailView(article: article)
        }
    }
}

#Preview {
    ArticleListView()
}
