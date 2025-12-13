//
//  TagBarView.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/11.
//
import SwiftUI

struct TagSelectionBar: View {
    let allTags: [Tag]
    let selectedTagIDs: [String]
    let onToggle: (Tag) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(allTags, id: \.self) { tag in
                    let isSelected = selectedTagIDs.contains(tag.id)
                    
                    Text(tag.label)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.blue.opacity(0.8) : Color.gray.opacity(0.3))
                        )
                        .foregroundStyle(isSelected ? Color.white : Color.primary)
                        .onTapGesture {
                            onToggle(tag)
                        }
                }
            }
        }
    }
}
