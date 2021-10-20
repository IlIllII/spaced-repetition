//
//  ContentView.swift
//  SpacedRepetition
//
//  Created by Jeremy Stein on 10/15/21.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: ViewModel
    @State var editing = false
    @State var newCard = false
    @State var questionField = ""
    @State var answerField = ""
    @State var xCoord = UIScreen.main.bounds.size.width / 2
    
    let width = UIScreen.main.bounds.size.width

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    if cardsRemaining() {
                        CardView(card: viewModel.currentCard)
                    } else {
                        VStack {
                            Text("Good work!")
                            Text("You're all caught up.")
                        }
                    }
                }
                    .contextMenu {
                        contextMenu
                    }
                    .position(x: xCoord, y: geometry.size.height/2)
                    .navigationBarHidden(true)
                .toolbar {
                    ToolbarItem(placement: .status) {
                        Button(action: {
                            questionField = ""
                            answerField = ""
                            newCard = true
                            editing = true
                        }, label: {
                            Image(systemName: "plus.rectangle.portrait")
                        })
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            if cardsRemaining() {
                                swipeCard {
                                    viewModel.gotCardWrong(viewModel.currentCard)
                                }
                            }
                        }, label: {
                            Text("Incorrect")
                                .opacity(cardsRemaining() ? 1 : 0)
                                .cornerRadius(20)
                        })
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            if cardsRemaining() {
                                swipeCard {
                                    viewModel.gotCardRight(viewModel.currentCard)
                                }
                            }
                        }, label: {
                            Text("Correct")
                                .opacity(cardsRemaining() ? 1 : 0)
                        })
                    }
                }
                .sheet(isPresented: $editing) {
                    CardEditor(viewModel: viewModel, newCard: newCard, questionField: self.$questionField, answerField: self.$answerField)
                }
            }
        }
    }
    
    /// Whether or not there are any cards with review dates before today.
    func cardsRemaining() -> Bool {
        return viewModel.currentCard.reviewDate < Date()
    }
    
    /// Animating xCoord for card swiping.
    ///
    /// - Parameter f: any function returning void. In this case it is going to be getting the card either right or wrong, which changes the view to a new card.
    func swipeCard(f: () -> Void) {
        withAnimation(.easeIn(duration: 0.3)) {
            xCoord = width * 2
        }
        f()
        withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
            xCoord = width / 2
        }
    }
    
    @ViewBuilder
    var contextMenu: some View {
        Button(action: {
            questionField = viewModel.currentCard.question
            answerField = viewModel.currentCard.answer
            newCard = false
            editing = true
        }, label: {
            HStack {
                Text("Edit")
                Image(systemName: "pencil")
            }
        })
        if #available(iOS 15.0, *) {
            Button(role: .destructive, action: {
                viewModel.deleteCard(viewModel.currentCard)
            }, label: {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            })
        } else {
            Button(action: {
                viewModel.deleteCard(viewModel.currentCard)
            }, label: {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            })
        }
            
    }
}








struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: ViewModel())
    }
}
