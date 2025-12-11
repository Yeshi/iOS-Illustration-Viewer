//
//  Illustration_ViewerApp.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/01.
//

import SwiftUI

@main
struct Illustration_ViewerApp: App {
    @StateObject private var repo = IllustrationRepository()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                           .environmentObject(repo)
        }
    }
}
