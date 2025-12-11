//
//  ImageView.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/04.
//
import SwiftUI

struct ImageView: View {
    let image: UIImage
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = lastScale * value
                    }
                    .onEnded { _ in
                        scale = min(max(scale,0.5),3.0)
                        lastScale = scale
                    }
            )
            // ダブルタップで元のスケールに
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded {
                        withAnimation(.spring()){
                            scale = 1.0
                            lastScale = 1.0
                        }
                    }
            )
            .ignoresSafeArea()
    }
    
}
