//
//  ContentView.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/01.
//

import SwiftUI

struct ContentView: View {
    let images = [
    "auch10b_17",
    "auch10b_18",
    "auch10b_19",
    "auch10b_21",
    "auch10b_22",
    "auch11a_11",
    "auch11c_29",
    "auch11c_30",
    "auch12b_11",
    "auch12b_12",
    "auch12b_13",
    "auch12b_14",
    "auch12b_17",
    "auch12b_25",
    "auch12b_28",
    "auch13a_2",
    "auch13a_21",
    "auch13a_30",
    "auch13e_5",
    "auch13e_9",
    "auch13e_19",
    "auch13e_24",
    "auch13e_30",
    "auch14a_5",
    "auch14a_8",
    "auch14a_10",
    "auch14a_23",
    "auch14a_26",
    "auch14a_29",
    "auch14a_30",
    "auch14b_8",
    "auch14b_11",
    "auch14b_12",
    "auch14b_13",
    "auch14b_14",
    "auch14c_25",
    "b_auch05_1"
    ]
        
    var body: some View {
        NavigationStack {
            ScrollView {
                let columns = Array(
                    repeating: GridItem(.flexible(), spacing: 8),
                    count:3
                )
                
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(images.indices, id: \.self) { index in
                        
                        NavigationLink(value: index){
                            ThumbnailView(imageName: images[index])
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Color(white: 0.95))
            .navigationDestination(for: Int.self) { index in
                DetailView(images: images, initialIndex: index)
            }
        }
    }
}

struct ThumbnailView: View {
    let imageName: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.15),lineWidth: 1)
                    )
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.width)
                    .clipped()
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}


#Preview {
    ContentView()
}
