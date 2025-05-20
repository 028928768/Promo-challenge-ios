//
//  ArticleCardView.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI

struct ArticleCardView: View {
    let article: Article
    @State private var currentPage = 0

    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $currentPage) {
                ForEach(article.imageUrls.indices, id: \.self) { index in
                    let urlString = article.imageUrls[index]
                    if let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                VStack(alignment: .leading, spacing: 8) {
                                    Color.gray
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                }
                                .shimmering()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .transition(.opacity)
                            case .failure(_):
                                Image("image-no-found")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                            @unknown default:
                                Color.clear
                            }
                            
                        } //; Images
                        .tag(index)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                    }
                }
            } //; Tabview
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 200)
            
            VStack(alignment: .leading) {
                Text(article.title.cleanedSummary)
                    .font(.headline)
                    .lineLimit(2)
                Text(article.content.cleanedSummary)
                    .font(.subheadline)
                    .lineLimit(3)
            
            }
            .padding()
        }
        .cornerRadius(6)
                
    } //: View;
}

#Preview {
    ArticleCardView(article: .preview)
}
