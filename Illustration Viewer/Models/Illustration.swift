//
//  Untitled.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/09.
//

import Foundation

struct Illustration: Identifiable, Codable {
    let id: String
    let filename: String
}

struct Tag: Identifiable, Codable, Hashable {
    let id: String
    var label: String
}

struct IllustrationUserData: Codable, Hashable {
    let id: String
    var tagIDs: [String] = []
    var viewCount: Int = 0
    var lastViewAt: Date? = nil
}
