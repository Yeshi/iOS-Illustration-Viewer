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
    @State private var showTagSettings = false
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count:3
    )
    
    private var filteredIllustrations: [Illustration] {
        let all = repo.illustrations
        
        guard !selectedTagIDs.isEmpty else {
            return all
        }
        
        return all.filter { illust in
            selectedTagIDs.allSatisfy{ illust.tagIDs.contains($0) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    TagFilterBar(
                        allTags: repo.allTags,
                        selectedTagIDs: $selectedTagIDs
                    )
                    Button {
                        showTagSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                }
                .sheet(isPresented: $showTagSettings){
                    TagSettingsView()
                        .environmentObject(repo)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                Divider()
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(Array(filteredIllustrations.enumerated()), id: \.1.id){_, illust in
                        NavigationLink {
                            if let globalIndex = repo.illustrations.firstIndex(where: { $0.id == illust.id }){
                                DetailView(initialIndex: globalIndex)
                            }
                            
                        } label: {
                            ThumbnailView(illustrations: illust)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Color(white: 0.95))
        }
        
    }
}

struct ThumbnailView: View {
    let illustrations: Illustration
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.15),lineWidth: 1)
                    )
                
                if let image = ImageLoader.loadImage(filename: illustrations.filename){
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
