//
//  ArticleCardSkeletonView.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI

struct ArticleCardSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Color.gray
                .frame(height: 200)
                .cornerRadius(12)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.6))
                .frame(height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.4))
                .frame(height: 14)
                .padding(.trailing, 40)
            Spacer()
        }
        .padding()
        .shimmering()
    }
}
