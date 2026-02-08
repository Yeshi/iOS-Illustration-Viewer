//
//  ImageLoader.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/10.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 300
    }
    
    func loadImage(filename: String) -> UIImage? {
        let key = filename as NSString
        
        if let cached = cache.object(forKey: key) {
            return cached
        }
        
        guard let url = Bundle.main.url(
            forResource: filename,
            withExtension: nil,
        ) else {
            print("image not found: \(filename)")
            return nil
        }
        
        guard let image = UIImage(contentsOfFile: url.path) else { return nil }

        cache.setObject(image, forKey: key)
        return image
    }
    
    func prefetch(filenames: [String]) {
        for name in filenames {
            _ = loadImage(filename: name)
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
