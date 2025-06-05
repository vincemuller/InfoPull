//
//  InfoPullApp.swift
//  InfoPull
//
//  Created by Vince Muller on 6/4/25.
//

import SwiftUI

@main
struct InfoPullApp: App {
    let networkManager = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            ConfigurationScreen()
                .onAppear {
                    Task {
                        try await networkManager.getArtefactsByGroup()
                        await networkManager.getPreviewImages()
                    }
                }
        }
    }
}
