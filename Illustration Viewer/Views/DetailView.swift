//
//  DetailView.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/02.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var repo: IllustrationRepository
    
    let ids: [String]
    @State private var currentIndex: Int
    @State private var isChromeHidden: Bool = false
    
    init(ids: [String], initialIndex: Int) {
        self.ids = ids
        _currentIndex = State(initialValue: min(max(initialIndex, 0), max(ids.count - 1, 0)))
    }
    
    private func illustration(for idx: Int) -> Illustration? {
        guard ids.indices.contains(idx) else { return nil }
        let id = ids[idx]
        return repo.illustrations.first(where: { $0.id == id })
    }
    
    private var currentIllustration: Illustration? {
        illustration(for: currentIndex)
    }
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(ids.indices, id: \.self){ idx in
                    if let illust = illustration(for: idx),
                       let image = ImageLoader.loadImage(filename: illust.filename) {
                        ImageView(image: image)
                            .tag(idx)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isChromeHidden.toggle()
                                }
                            }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: isChromeHidden ? .never : .automatic))
            
            if let illust = currentIllustration, !isChromeHidden {
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
        .toolbar(isChromeHidden ? .hidden : .visible, for: .navigationBar)
    }
    
}
