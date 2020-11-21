//
//  OSButtonStyle.swift
//  iRingTunes Pro
//
//  Created by danxnu on 20/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import SwiftUI

struct OSSetupButtonStyle: ButtonStyle {
    
    @State var backgroundColor: Color = .blue
    
    func makeBody(configuration: Configuration) -> some View {
        MyButton(configuration: configuration, backgroundColor: backgroundColor)
    }
        
    struct MyButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        @State var backgroundColor: Color = .blue
        
        var body: some View {
            configuration.label
            .font(Font.body.bold())
            .foregroundColor(Color.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(self.isEnabled ? self.backgroundColor : Color.gray)
            )
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .animation(.linear(duration: 0.1))
        }
    }
    
}

struct OSLabelModifier: ViewModifier {
    @State var backgroundColor: Color = Color.blue
    
    func body(content: Content) -> some View {
        content
        .font(Font.body.bold())
        .foregroundColor(Color.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(self.backgroundColor)
        )
    }
}

extension View {
    func osLabelStyle(color: Color = .blue) -> some View {
        self.modifier(OSLabelModifier(backgroundColor: color))
    }
}
