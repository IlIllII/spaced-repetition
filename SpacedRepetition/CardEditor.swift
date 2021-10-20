//
//  CardEditor.swift
//  SpacedRepetition
//
//  Created by Jeremy Stein on 10/15/21.
//

import SwiftUI

struct CardEditor: View {
    var viewModel: ViewModel
    var newCard: Bool
    @Environment(\.presentationMode) var presentationMode
    @Binding var questionField: String
    @Binding var answerField: String
    
    var body: some View {
        VStack {
            Form {
                questionSection
                answerSection
                }
            Button(action: {
                if newCard == false {
                    viewModel.editCard(viewModel.currentCard, question: questionField, answer: answerField)
                } else {
                    viewModel.addCard(question: questionField, answer: answerField)
                }
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(newCard == false ? "Submit Edit" : "Add Card")
            })
                .padding()
        }
    }
    
    var questionSection: some View {
        Section(header: Text("Question")) {
            TextField("", text: $questionField)
        }
    }
    
    var answerSection: some View {
        Section(header: Text("Answer")) {
            TextEditor(text: $answerField)
        }
    }
}

//struct CardEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        CardEditor()
//    }
//}
