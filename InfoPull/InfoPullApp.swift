//
//  InfoPullApp.swift
//  InfoPull
//
//  Created by Vince Muller on 6/4/25.
//

import SwiftUI

@main
struct InfoPullApp: App {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ConfigurationScreen()
                .environmentObject(viewModel)
        }
    }
}
