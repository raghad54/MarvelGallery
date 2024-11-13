//
//  APIService.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation

protocol APIServiceProtocol {
    func getCharactersURL() -> URL?
    func getCharacterDetailsURL(for id: Int) -> URL?
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://gateway.marvel.com/v1/public"
    private let publicKey = "b9cfdbb42b402814a37567a6b7c40d3a"
    
    func getCharactersURL() -> URL? {
        URL(string: "\(baseURL)/characters?apikey=\(publicKey)")
    }
    
    func getCharacterDetailsURL(for id: Int) -> URL? {
        URL(string: "\(baseURL)/characters/\(id)?apikey=\(publicKey)")
    }
}
