//
//  ArticleListView.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI

struct ArticleListView: View {
    @StateObject private var viewModel = ArticleListViewModel()
    
    // MARK: Previews
    init(viewModel: ArticleListViewModel = ArticleListViewModel()) {
       _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ArticleCardSkeletonView()
            case .success(let t):
                VStack {
                    //: Header
                    HStack {
                        Image("primo-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                        
                        Text("PRIMO")
                            .fontWeight(.bold)
                    }
                    List {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(destination: ArticleDetailView(article: article)) {
                                ArticleCardView(article: article)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    )
                                    .padding(.vertical, 4)
                                    .listRowInsets(EdgeInsets()) // Remove default padding
                                    .listRowBackground(Color.clear)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowBackground(Color.clear)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .background(Color(UIColor.systemGray6)) // light grey background
                }
            default:
                EmptyView()
            }
        } //: Navigation Stack
        .onAppear {
            viewModel.loadArticles()
        }

    }
}

#Preview {
    ArticleListView()
}
