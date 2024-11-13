//
//  CharacterModel.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation

struct MarvelCharacterResponse: Codable {
    let code: Int
    let status: String
    let data: MarvelCharacterData
}

struct MarvelCharacterData: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [CharacterListModel]
}

struct CharacterListModel: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    let path: String
    let `extension`: String
}
