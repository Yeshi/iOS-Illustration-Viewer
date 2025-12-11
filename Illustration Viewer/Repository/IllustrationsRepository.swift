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

    init() {
        load()
    }

    private func load() {
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
}
