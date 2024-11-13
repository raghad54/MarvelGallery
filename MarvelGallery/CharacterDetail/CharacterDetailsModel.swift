//
//  ComicModel.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation

struct CharacterDetailsModel: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let comics: ComicsList
}

struct ComicsList: Decodable {
    let items: [Comic]
}

struct Comic: Decodable, Identifiable {
    var id: String { resourceURI }
    let resourceURI: String
    let name: String
}
