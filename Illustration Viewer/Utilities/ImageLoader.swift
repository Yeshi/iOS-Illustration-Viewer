//
//  ImageLoader.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/10.
//

import UIKit

struct ImageLoader {
    static func loadImage(filename: String) -> UIImage? {
        
        guard let url = Bundle.main.url(
            forResource: filename,
            withExtension: nil,
        ) else {
            print("image not found: \(filename)")
            return nil
        }
        
        
        return UIImage(contentsOfFile: url.path)
    }
}
