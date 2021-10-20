//
//  model.swift
//  SpacedRepetition
//
//  Created by Jeremy Stein on 10/15/21.
//

import Foundation


/// Model for MVVM App.
struct Model: Codable {
    var cards = [Card]()
    private var uniqueCardId: Int = 0
    
    /// Card struct containing card content.
    struct Card: Identifiable, Hashable, Codable {
        var question: String
        var answer: String
        var reviewDate: Date
        var learningBucket: Int
        let id: Int
        
        fileprivate init(question: String, answer: String, reviewDate: Date, learningBucket: Int, id: Int) {
            self.question = question
            self.answer = answer
            self.reviewDate = reviewDate
            self.learningBucket = learningBucket
            self.id = id
        }
    }
    
    init() { }
    
    
    // MARK: - JSON encoding and decoding for persistence
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(Model.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try Model(json: data)
    }
        
    /// Add a new card to the deck with a review date 24 hours from now.
    mutating func addCard(question: String, answer: String) {
        uniqueCardId += 1
        let reviewDate = Date().addingTimeInterval(CONSTANTS.oneDay)
        cards.append(Card(
            question: question, answer: answer, reviewDate: reviewDate, learningBucket: 0, id: uniqueCardId)
        )
    }
    
    struct CONSTANTS {
        static let oneDay: Double = 86400 // in seconds
    }
}
