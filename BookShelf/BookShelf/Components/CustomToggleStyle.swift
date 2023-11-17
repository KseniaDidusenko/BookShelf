//
//  CustomToggle.swift
//  BookShelf
//
//  Created by Ksenia on 16.11.2023.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
            HStack {
                Image(systemName: configuration.isOn ? "headphones" : "text.alignleft")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 71, height: 44, alignment: .center)
                    .overlay(
                        Circle()
                            .foregroundColor(.white)
                            .padding(.all, 3)
                            .offset(x: configuration.isOn ? 11 : -11, y: 0)
                            .animation(Animation.linear(duration: 0.1))
                    ).cornerRadius(20)
                    .onTapGesture { configuration.isOn.toggle() }
            }
        }
}
