//
//  ShimmerViewModifier.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI

struct ShimmerViewModifier: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .redacted(reason: .placeholder)
            .overlay(
                GeometryReader { geometry in
                    Color.white
                        .opacity(0.6)
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, .white.opacity(0.4), .clear]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .rotationEffect(.degrees(30))
                                .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                        )
                        .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
                }
            )
            .onAppear {
                isAnimating = true
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerViewModifier())
    }
}
