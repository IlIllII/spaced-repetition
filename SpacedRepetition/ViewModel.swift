//
//  ViewModel.swift
//  SpacedRepetition
//
//  Created by Jeremy Stein on 10/15/21.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published private(set) var model: Model {
        didSet {
            autosave()
        }
    }
    
    /// Load in cards or create an empty deck if no save exists.
    init() {
        // If an autosave exists, load it
        // If not, create empty model
        if let url = Autosave.url, let autosaved = try? Model(url: url) {
            model = autosaved
        } else {
            model = Model()
            model.addCard(question: "Sample Question", answer: "Sample Answer")
        }
    }
    
    var cards: [Model.Card] {
        return model.cards
    }
    
    var currentCard: Model.Card {
        return cards[0]
    }
    
    
    // MARK: - autosave
    
    private struct Autosave {
        static let filename = "Autosaved"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        do {
            let data: Data = try model.json()
            try data.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("Couldn't encode data as JSON because \(encodingError.localizedDescription)")
        } catch let error {
            print("Error = \(error)")
        }
    }
    
    /// Sorts the card deck in place.
    ///
    /// Insertion sort is used because at most one card will be out of order, making it O(n)
    private func insertionSortCards() {
        for index in 1..<model.cards.count {
            let card = model.cards[index]
            var currentPosition = index
            
            while currentPosition > 0 && model.cards[currentPosition - 1].reviewDate > card.reviewDate {
                model.cards[currentPosition] = model.cards[currentPosition - 1]
                currentPosition -= 1
            }
            model.cards[currentPosition] = card
        }
    }
    
    
    // MARK: - Intents
    
    func addCard(question: String, answer: String) {
        model.addCard(question: question, answer: answer)
        insertionSortCards()
    }
    
    func deleteCard(_ card: Model.Card) {
        if let index = model.cards.firstIndex(where: { $0.id == card.id}) {
            model.cards.remove(at: index)
        }
    }
    
    func editCard(_ card: Model.Card, question: String, answer: String) {
        if let index = model.cards.firstIndex(where: { $0.id == card.id}) {
            model.cards[index].question = question
            model.cards[index].answer = answer
        }
    }
    
    /// Move card ahead one bucket and resort deck.
    func gotCardRight(_ card: Model.Card) {
        if let index = model.cards.firstIndex(where: { $0.id == card.id}) {
            model.cards[index].learningBucket += 1
            let exponent = Double(model.cards[index].learningBucket)
            model.cards[index].reviewDate = Date().addingTimeInterval(pow(CONSTANTS.oneDay, exponent))
        }
        insertionSortCards()
    }
    
    /// Move card back one bucket and resort deck.
    func gotCardWrong(_ card: Model.Card) {
        if let index = model.cards.firstIndex(where: { $0.id == card.id}) {
            model.cards[index].learningBucket -= 1
            let exponent = Double(model.cards[index].learningBucket)
            model.cards[index].reviewDate = Date().addingTimeInterval(pow(CONSTANTS.oneDay, exponent))
        }
        insertionSortCards()
    }
    
    struct CONSTANTS {
        static let oneDay: Double = 86400 // seconds in a day
    }
}
