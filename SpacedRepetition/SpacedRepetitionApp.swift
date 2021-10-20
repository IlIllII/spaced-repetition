//
//  SpacedRepetitionApp.swift
//  SpacedRepetition
//
//  Created by Jeremy Stein on 10/15/21.
//

import SwiftUI

@main
struct SpacedRepetitionApp: App {
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel)
        }
    }
}
