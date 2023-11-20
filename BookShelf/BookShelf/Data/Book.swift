//
//  Book.swift
//  BookShelf
//
//  Created by Ksenia on 19.11.2023.
//

import Foundation

struct Book: Codable, Equatable, Identifiable {
    var id = UUID()
    
    //    let url: String
    let name: String
    let chaptersNames: [String]
//    let isbn: String
//    let authors: [String]
//    let numberOfPages: Int
//    let publisher: String
//    let country: String
//    let mediaType, released: String
//    let characters, povCharacters: [String]
}

extension Book {
    static let mock: Book = Book(
        name: "Sense and sensibility",
        chaptersNames: [
            "sense_sensibility_01",
            "sense_sensibility_02",
            "sense_sensibility_03",
            "sense_sensibility_04",
            "sense_sensibility_05"
        ]
        
    )
}
