//
//  DetailView.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/02.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var repo: IllustrationRepository
    @State private var currentIndex: Int

    init(initialIndex: Int) {
        _currentIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(repo.illustrations.indices, id: \.self){ idx in
                let illust = repo.illustrations[idx]
                ZStack {
                    if let image = ImageLoader.loadImage(filename: illust.filename){
                        ImageView(image: image)
                    }
                }.tag(idx)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
       
    }
   
}

