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
        
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count:3
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(repo.illustrations.enumerated(), id: \.1.id){index, illust in
                        NavigationLink {
                            DetailView(initialIndex: index)
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
