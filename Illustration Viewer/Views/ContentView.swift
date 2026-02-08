//
//  ContentView.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/01.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var repo: IllustrationRepository
    
    @State private var selectedTagIDs: Set<String> = []
    @State private var excludedTagIDs: Set<String> = []
    @State private var showUntaggedOnly: Bool = false
    @State private var showTagSettings = false
    @State private var displayIDs: [String] = []
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    TagFilterBar(
                        allTags: repo.allTags,
                        selectedTagIDs: $selectedTagIDs,
                        excludedTagIDs: $excludedTagIDs,
                        showUntaggedOnly: $showUntaggedOnly
                    )
                    Button {
                        showTagSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                }
                .sheet(isPresented: $showTagSettings, onDismiss: {
                    refreshDisplayIDs()
                }) {
                    TagSettingsView()
                        .environmentObject(repo)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                Divider()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(Array(displayIDs.enumerated()), id: \.element) { index, id in
                            if let illust = repo.illustrationByID(id) {
                                NavigationLink {
                                    DetailView(ids: displayIDs, initialIndex: index)
                                } label: {
                                    ThumbnailView(illustration: illust)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(white: 0.95))
            }
        }
        .onAppear {
            // 初回リセット
            refreshDisplayIDs()
        }
        // フィルタ変更時の再計算
        .onChange(of: selectedTagIDs) { _, _ in refreshDisplayIDs() }
        .onChange(of: excludedTagIDs) { _, _ in refreshDisplayIDs() }
        .onChange(of: showUntaggedOnly) { _, _ in refreshDisplayIDs() }
        .onChange(of: repo.allTags) { _, _ in refreshDisplayIDs() }
        .onChange(of: repo.listNeedsRefreshTick) { _, _ in refreshDisplayIDs() }
    }
    
    private func refreshDisplayIDs() {
        displayIDs = makeDisplayIDs()
    }
    
    private func makeDisplayIDs() -> [String] {
        let all = repo.illustrations
        // json配列順
        let jsonOrder: [String: Int] = Dictionary(
            uniqueKeysWithValues: all.enumerated().map { ($0.element.id, $0.offset) }
        )
        
        // フィルタ
        let filtered = all.filter { illust in
            let tags = repo.tagIDs(for: illust.id)
            
            if showUntaggedOnly {
                return tags.isEmpty
            }
            
            if !excludedTagIDs.isEmpty,
               excludedTagIDs.contains(where: tags.contains) {
                return false
            }
            
            if selectedTagIDs.isEmpty { return true }
            
            return selectedTagIDs.allSatisfy(tags.contains)
        }
        
        //ソート
        let sorted = filtered.sorted { a, b in
            let sa = repo.displayScore(for: a.id)
            let sb = repo.displayScore(for: b.id)
            if sa != sb { return sa > sb }
            
            let da = repo.lastViewAt(for: a.id)
            let db = repo.lastViewAt(for: b.id)
            if da != db { return da > db }
            
            return (jsonOrder[a.id] ?? Int.max) < (jsonOrder[b.id] ?? Int.max)
        }
        return sorted.map(\.id)
    }
}

struct ThumbnailView: View {
    let illustration: Illustration
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                
                if let image = ImageLoader.loadImage(filename: illustration.filename) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.width)
                        .clipped()
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = IllustrationRepository()
        ContentView()
            .environmentObject(repo)
    }
}
