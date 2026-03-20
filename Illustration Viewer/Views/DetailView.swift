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
    @State private var isInfoPresented: Bool = false
    
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
                       let image = ImageLoader.shared.loadImage(filename: illust.filename) {
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
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
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

        .toolbar(isChromeHidden ? .hidden : .visible, for: .navigationBar)
        .toolbar {
        #if DEBUG
            if let illust = currentIllustration, !isChromeHidden {
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        isInfoPresented = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        #endif
        }
        .alert("Debug Info",isPresented: $isInfoPresented) {
            Button("OK", role: .cancel){ }
        } message: {
            if let illust = currentIllustration {
                Text("""
                Count:  \(repo.viewCount(for: illust.id))
                Filename: \(illust.filename)
                """)
            } else {
                Text("No Content")
            }
        }
        
        .onAppear {
            if let illust = currentIllustration {
                repo.markViewed(id: illust.id)
            }
        }
        .onChange(of: currentIndex) { _, _ in
            if let illust = currentIllustration {
                repo.markViewed(id: illust.id)
            }
            let idxs = [currentIndex - 1, currentIndex, currentIndex + 1]
            let names = idxs.compactMap { i -> String? in
                guard ids.indices.contains(i),
                      let ill = repo.illustrationByID(ids[i]) else { return nil }
                return ill.filename
            }
            ImageLoader.shared.prefetch(filenames: names)
        }
        .onDisappear {
            repo.requestListRefresh()
        }
    }
    
}
