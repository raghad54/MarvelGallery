//
//  CharacterModel.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation

struct CharacterListModel: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Decodable {
    let path: String
    let thumbnailExtension: String
    
    var url: URL? {
        URL(string: "\(path).\(thumbnailExtension)")
    }
}
