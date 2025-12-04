//
//  DetailView.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/02.
//

import SwiftUI

struct DetailView: View {
    let images: [String]
    
    @State private var selectedIndex: Int
    
    init(images: [String], initialIndex: Int) {
        self.images = images
        _selectedIndex = State(initialValue: initialIndex)
    }
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(images.indices, id: \.self){ idx in
                ImageView(imageName: images[idx])
                    .tag(idx)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}
