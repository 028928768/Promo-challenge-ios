//
//  ArticleCardView.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI

struct ArticleCardView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(article.title)
                .font(.headline)
            Text(article.description)
                .font(.subheadline)
                .lineLimit(2)
        }
        .padding()
    }
}

//#Preview {
//    // TODO: Mockup Article data
//   // ArticleCardView(article: )
//}
