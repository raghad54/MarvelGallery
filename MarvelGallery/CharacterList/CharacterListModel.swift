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
    let comics: MarvelResourceList
    let series: MarvelResourceList
    let stories: MarvelResourceList
    let events: MarvelResourceList
    var imageUrl: URL? {
        thumbnail.imageUrl ?? URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg")
    }
}

struct Thumbnail: Codable {
    let path: String
    let `extension`: String
    var imageUrl: URL? {
        let imageUrlString = path.replacingOccurrences(of: "http:", with: "https:") + "." + `extension`
        return URL(string: imageUrlString) ?? nil
    }
}

struct MarvelResourceList: Codable {
    let available: Int
    let collectionURI: String
    let items: [MarvelResourceItem]
}

struct MarvelResourceItem: Codable, Identifiable {
    let resourceURI: String
    let name: String

    var id: String {
        resourceURI
    }
    var imageUrl: String {
        "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"
    }
}
