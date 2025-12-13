//
//  Untitled.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/09.
//

struct Illustration: Identifiable, Codable {
    let id: String
    let filename: String
    var tagIDs: [String]
    var rating: Int
}

struct Tag: Identifiable, Codable, Hashable {
    let id: String
    var label: String
}

struct IllustrationUserData: Codable, Hashable {
    let id: String
    var tagIDs: [String]
    var rating: Int
}
