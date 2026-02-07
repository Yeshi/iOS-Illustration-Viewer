//
//  ImageView.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/04.
//
import SwiftUI

struct ImageView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .ignoresSafeArea()
    }
    
}
