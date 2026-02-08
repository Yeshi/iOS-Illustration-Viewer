//
//  IllustrationsRepository.swift
//  Illustration Viewer
//
//  Created by Yeshi on 2025/12/09.
//
import Foundation
import Combine

final class IllustrationRepository: ObservableObject {
    @Published var illustrations: [Illustration] = []
    @Published var allTags: [Tag] = []
    @Published private var userDataByID: [String: IllustrationUserData] = [:]
    
    var tagByID: [String: Tag] {
        Dictionary(uniqueKeysWithValues: allTags.map { ($0.id, $0) } )
    }
    
    private var userDataURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("user_illustrations.json")
    }
    private var tagsURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("tags.json")
    }
    
    init() {
        loadSeeds()
        loadTags()
        applyUserDataIfExists()
    }
    
    private func loadSeeds() {
        guard let url = Bundle.main.url(forResource: "illustration_list",withExtension: "json")else {
            print("ファイルがないよ")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Illustration].self, from: data)
            self.illustrations = decoded
        } catch {
            print("ファイル読み込みエラーだよ: \(error)")
        }
    }
    
    private func loadTags() {
        guard let url = tagsURL, let data = try? Data(contentsOf: url) else {
            allTags = [
                .init(id: "0", label: "Fav" )
            ]
            saveTags()
            return
        }
        
        do {
            allTags = try JSONDecoder().decode([Tag].self, from: data)
        } catch {
            print("タグのロードエラー： \(error)")
        }
    }
    
    private func applyUserDataIfExists() {
        guard let url = userDataURL else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let userItems = try decoder.decode([IllustrationUserData].self, from: data)
            userDataByID = Dictionary(uniqueKeysWithValues: userItems.map{ ($0.id, $0) } )
            
            saveUserData()
        } catch {
            print("userData読み込みなんか失敗っぽい： \(error)")
        }
    }
    
    private func saveUserData() {
        guard let url = userDataURL else { return }
        
        let userItems = userDataByID.values.compactMap { item -> IllustrationUserData? in
            if item.tagIDs.isEmpty && item.viewCount == 0 && item.lastViewAt == nil {
                return nil
            }
            return item
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            let data = try encoder.encode(userItems)
            try data.write(to: url,options: [.atomic])
        }catch {
            print("userData保存なんか失敗っぽい： \(error)")
        }
    }
    
    func tagIDs(for id: String) -> [String] {
        userDataByID[id]?.tagIDs ?? []
    }

    func toggleTag(_ tagID: String, for id: String) {
        var item = userDataByID[id] ?? IllustrationUserData(id: id)

        if item.tagIDs.contains(tagID) {
            item.tagIDs.removeAll { $0 == tagID }
        } else {
            item.tagIDs.append(tagID)
        }
        
        userDataByID[id] = item
        saveUserData()
    }
    
    func saveTags() {
        guard let url = tagsURL else { return }
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(allTags)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("タグ保存なんか失敗っぽい： \(error)")
        }
    }
    func addTag(label: String) {
        let next = (allTags.compactMap{ Int($0.id)}.max() ?? 0) + 1
        allTags.append(.init(id: String(next), label: label))
        saveTags()
    }
    func updateTag(id: String, newLabel: String) {
        guard let i = allTags.firstIndex(where: { $0.id == id }) else { return }
        allTags[i].label = newLabel
        saveTags()
    }}
