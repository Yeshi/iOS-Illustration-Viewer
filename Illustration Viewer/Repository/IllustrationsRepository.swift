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
    
    lazy var tagID: [String: Tag] = {
        Dictionary(uniqueKeysWithValues: allTags.map { ($0.id, $0) } )
    }()
    
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
            let userItems = try JSONDecoder().decode([IllustrationUserData].self, from: data)
            let map = Dictionary(uniqueKeysWithValues: userItems.map{ ($0.id, $0) } )
            
            for i in illustrations.indices {
                let id = illustrations[i].id
                if let u = map[id] {
                    illustrations[i].tagIDs = u.tagIDs
                    illustrations[i].rating = u.rating
                }
            }
        } catch {
            print("userData読み込みなんか失敗っぽい： \(error)")
        }
    }
    
    private func saveUserData() {
        guard let url = userDataURL else { return }
        
        let userItems: [IllustrationUserData] = illustrations.compactMap{ illlust in
            if illlust.tagIDs.isEmpty && illlust.rating == 0 {
                return nil
            }
            return IllustrationUserData(id: illlust.id, tagIDs: illlust.tagIDs, rating: illlust.rating)
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(userItems)
            try data.write(to: url,options: [.atomic])
        }catch {
            print("userData保存なんか失敗っぽい： \(error)")
        }
    }
    
    func toggleTag(_ tagID: String, for index:Int){
        guard illustrations.indices.contains(index) else { return }
        
        var illust = illustrations[index]
        if illust.tagIDs.contains(tagID) {
            illust.tagIDs.removeAll { $0 == tagID }
        } else {
            illust.tagIDs.append(tagID)
        }
        illustrations[index] = illust
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
