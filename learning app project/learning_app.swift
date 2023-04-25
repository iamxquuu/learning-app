//
//  learning_app_projectApp.swift
//  learning app project
//
//  Created by Marcel Maciaszek on 23/04/2023.
//

import SwiftUI

@main
struct learning_app: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
