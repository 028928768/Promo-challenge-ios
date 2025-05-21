//
//  CapesuleButtonStyle.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation
import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
