//
//  ArticleListView.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI

struct ArticleListView: View {
    @StateObject private var viewModel: ArticleListViewModel
    
    // MARK: Previews
    @MainActor
    init(viewModel: ArticleListViewModel? = nil) {
        if let vm = viewModel {
            _viewModel = StateObject(wrappedValue: vm)
        } else {
            _viewModel = StateObject(wrappedValue: ArticleListViewModel())
        }
    }
    
    var body: some View {
        NavigationStack {
            
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ArticleCardSkeletonView()
            case .success(_):
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
            case .failed(let error):
                VStack {
                    Text(error.localizedDescription)
                    Button("Reload") {
                        Task {
                            await viewModel.loadArticles()
                        }
                    }
                    .buttonStyle(CapsuleButtonStyle(backgroundColor: .green))
                }
            }
            
        } //: Navigation Stack
        .onAppear {
            Task {
                await viewModel.loadArticles()
            }
        }

    }
}

#Preview {
    ArticleListView()
}
