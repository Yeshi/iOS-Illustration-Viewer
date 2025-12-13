//
//  TagSettingsView.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/13.
//

import SwiftUI

struct TagSettingsView: View {
    @EnvironmentObject var repo: IllustrationRepository
    @Environment(\.dismiss) private var dismiss
    
    @State private var newTagName: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Tag List") {
                    ForEach(repo.allTags){ tag in
                        TextField(
                            "タグ名",
                            text: Binding(
                                get: { tag.label },
                                set: { repo.updateTag(id: tag.id, newLabel: $0) }
                            )
                        )
                    }
                }
                Section("Add Tag") {
                    HStack {
                        TextField("タグ名", text: $newTagName)
                        Button("Add") {
                            let trimmed = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            repo.addTag(label: trimmed)
                            newTagName = ""
                        }
                        .disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .navigationTitle("タグ追加、名前変更")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button("×") { dismiss() }
                }
                
            }
        }
    }
}
