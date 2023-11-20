//
//  BookShelfApp.swift
//  BookShelf
//
//  Created by Ksenia on 15.11.2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct BookShelfApp: App {
    private static let store = Store(initialState: BookPlayer.State(book: Book.mock), reducer: {
        BookPlayer()
    })
    
    var body: some Scene {
        WindowGroup {
            BookPlayerView(store: BookShelfApp.store)
        }
    }
}
