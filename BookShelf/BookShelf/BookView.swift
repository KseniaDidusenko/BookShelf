//
//  BookPlayerView.swift
//  BookShelf
//
//  Created by Ksenia on 15.11.2023.
//

import ComposableArchitecture
import SwiftUI

struct AppState {
    
}

enum AppAction {
    
}

struct AppEnvironment {
    
}

//let appReducer = Reducer<AppState, AppAction> { state, action in
//    switch action {
//
//    }
//}

struct BookView: View {

    @State var preselectedIndex = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                player
                PlayerView()
                switchMode
            }
        }
        .background(Color("Background"))
    }
}

extension BookView {
    var player: some View {
        VStack (alignment: .center, spacing: 8) {
            Image("BookCover")
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .clipped()
                .aspectRatio(1, contentMode: .fit)
//                .frame(width: 360, height: 300)
                .padding(.bottom, 24)
                .padding(.leading, 48)
                .padding(.trailing, 48)
                .padding(.top, 20)
//                .clipShape(RoundedRectangle(cornerRadius: 40))
//                .overlay(RoundedRectangle(cornerRadius: 10))
            
        }
        .padding(.top)
    }
    
    var switchMode: some View {
        SegmentedPickerView(
            selection: $preselectedIndex,
            size: CGSize(width: 150, height: 70),
            segmentLabels: ["headphones", "text.alignleft" ]
        )
        .padding(.bottom, 10)
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView()
    }
}
