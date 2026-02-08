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

    enum CodingKeys: String, CodingKey {
        case id, tagIDs, viewCount, lastViewAt
        // 旧データに rating がある可能性があるなら case rating を足してもOK（読むだけ）
        case rating
    }

    init(id: String, tagIDs: [String] = [], viewCount: Int = 0, lastViewAt: Date? = nil) {
        self.id = id
        self.tagIDs = tagIDs
        self.viewCount = viewCount
        self.lastViewAt = lastViewAt
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        id = try c.decode(String.self, forKey: .id)
        tagIDs = try c.decodeIfPresent([String].self, forKey: .tagIDs) ?? []
        viewCount = try c.decodeIfPresent(Int.self, forKey: .viewCount) ?? 0
        lastViewAt = try c.decodeIfPresent(Date.self, forKey: .lastViewAt)

        // もし旧JSONに rating があったら、ここで移行もできる（今は不要なら無視でOK）
        // let oldRating = try c.decodeIfPresent(Int.self, forKey: .rating) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(tagIDs, forKey: .tagIDs)
        try c.encode(viewCount, forKey: .viewCount)
        try c.encodeIfPresent(lastViewAt, forKey: .lastViewAt)
    }
}
