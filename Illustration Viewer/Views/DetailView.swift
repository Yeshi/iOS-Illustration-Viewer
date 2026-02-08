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
                    selectedTagIDs: repo.tagIDs(for: illust.id),
                    onToggle: { tag in
                        repo.toggleTag(tag.id, for: illust.id)
                    }
                )
                .padding(.vertical, 8)
                .padding(.horizontal)
            }
        }
        #if DEBUG
        .overlay(alignment: .bottomTrailing) {
            if let illust = currentIllustration {
                Text("Count: \(repo.viewCount(for: illust.id))")
                    .font(.caption)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(12)
                    .opacity(isChromeHidden ? 0.2 : 1.0)
            }
        }
        #endif

        .toolbar(isChromeHidden ? .hidden : .visible, for: .navigationBar)
        .onAppear {
            if let illust = currentIllustration {
                repo.markViewed(id: illust.id)
            }
        }
        .onChange(of: currentIndex) { _, _ in
            if let illust = currentIllustration {
                repo.markViewed(id: illust.id)
            }
        }
        .onDisappear {
            repo.requestListRefresh()
        }
    }
    
}
