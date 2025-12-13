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
    
    // 表示中のイラスト
    private var currentIllustration: Illustration? {
        guard repo.illustrations.indices.contains(currentIndex) else { return nil }
        return repo.illustrations[currentIndex]
    }
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(repo.illustrations.indices, id: \.self){ idx in
                    let illust = repo.illustrations[idx]
                    if let image = ImageLoader.loadImage(filename: illust.filename){
                        ImageView(image: image)
                            .tag(idx)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            if let illust = currentIllustration {
                TagSelectionBar(
                    allTags: repo.allTags,
                    selectedTagIDs: illust.tagIDs,
                    onToggle: { tag in
                        if let idx = repo.illustrations.firstIndex(where: { $0.id == illust.id }) {
                            repo.toggleTag(tag.id, for: idx)
                        }
                    }
                )
                .padding(.vertical, 8)
                .padding(.horizontal)
            }
        }
    }
    
}

