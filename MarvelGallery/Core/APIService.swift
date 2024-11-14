//
//  APIService.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation
import CryptoKit

protocol APIServiceProtocol {
    func getCharactersURL(offset: Int, limit: Int, searchText: String?) -> URL?
    func getCharacterDetailsURL(for id: Int) -> URL?
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://gateway.marvel.com/v1/public"
    private let publicKey = "b9cfdbb42b402814a37567a6b7c40d3a"

    func getCharactersURL(offset: Int, limit: Int, searchText: String?) -> URL? {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let hash = generateMarvelHash(timestamp: timestamp)
        
        var urlString = "\(baseURL)/characters?apikey=\(publicKey)&ts=\(timestamp)&hash=\(hash)&offset=\(offset)&limit=\(limit)"
        
        if let searchText = searchText, !searchText.isEmpty {
            urlString += "&name=\(searchText)"
        }
        
        return URL(string: urlString)
    }
    
    func getCharacterDetailsURL(for id: Int) -> URL? {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let hash = generateMarvelHash(timestamp: timestamp)
        
        let urlString = "\(baseURL)/characters/\(id)?apikey=\(publicKey)&ts=\(timestamp)&hash=\(hash)"
        return URL(string: urlString)
    }
    
    private func generateMarvelHash(timestamp: String) -> String {
        let privateKey = "4bc8a35dc9d43984099a9c0b0fc810169847c2d2"
        let publicKey = "b9cfdbb42b402814a37567a6b7c40d3a"
        
        let hashString = timestamp + privateKey + publicKey
        
        let hash = Insecure.MD5.hash(data: Data(hashString.utf8))
        
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
