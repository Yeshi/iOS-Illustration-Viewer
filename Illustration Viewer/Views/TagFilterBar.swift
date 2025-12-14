//
//  TagFilterBar.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/13.
//

import SwiftUI

struct TagFilterBar: View {
    let allTags: [Tag]
    @Binding var selectedTagIDs: Set<String>
    @Binding var showUntaggedOnly: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(allTags) { tag in
                    let isSelected = selectedTagIDs.contains(tag.id)
                    
                    Text(tag.label)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(isSelected ? Color.blue.opacity(0.85) : Color.gray.opacity(0.25))
                        )
                        .foregroundStyle(isSelected ? Color.white : Color.primary)
                        .onTapGesture {
                            if showUntaggedOnly {
                                showUntaggedOnly = false
                            }
                            if isSelected {
                                selectedTagIDs.remove(tag.id)
                            } else {
                                selectedTagIDs.insert(tag.id)
                            }
                        }
                }
                // タグ未設定絞り込み
                let isUntaggedSelected = showUntaggedOnly
                Text("未設定")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(isUntaggedSelected ? Color.blue.opacity(0.85) : Color.gray.opacity(0.25))
                    )
                    .foregroundStyle(isUntaggedSelected ? Color.white : Color.primary)
                    .onTapGesture {
                        showUntaggedOnly.toggle()
                        if showUntaggedOnly {
                            selectedTagIDs.removeAll()
                        }
                    }
                

            }
        }
    }
}
