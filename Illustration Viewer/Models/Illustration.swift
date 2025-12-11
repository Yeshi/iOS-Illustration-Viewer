//
//  Untitled.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/09.
//

struct Illustration: Identifiable, Codable {
    let id: String
    let filename: String
    var title: String
    var tags: [String]
    var rating: Int
}
