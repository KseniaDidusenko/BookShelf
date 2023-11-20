//
//  Book.swift
//  BookShelf
//
//  Created by Ksenia on 19.11.2023.
//

import Foundation

struct Book: Codable, Equatable, Identifiable {
    var id = UUID()
    let name: String
    let chaptersNames: [String]
    let chaptersDescription: [String]
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
        ],
        chaptersDescription: [
            "The Dashwood ladies have a change of situation",
            "Mr. and Mrs. John Dashwood discuss his father's last wishes",
            "The abilities and taste of Mr. Edward Ferrars",
            "Marianne and Elinor discuss Mr. Ferrars; Fanny makes her family's position clear",
            "Goodbye to dear, dear Norland"
        ]
    )
}
