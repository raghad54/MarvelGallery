//
//  MarvelOperations.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation
import Combine
import CryptoKit

protocol MarvelOperationsProtocol {
    func fetchCharacters(offset: Int, limit: Int, searchText: String) -> AnyPublisher<[CharacterListModel], Error>
    func generateMarvelHash() -> String
}


class MarvelOperations: MarvelOperationsProtocol {
   
    private let networkManager: NetworkManaging
    private let apiService: APIServiceProtocol
    private let privateKey = "4bc8a35dc9d43984099a9c0b0fc810169847c2d2"
    private let publicKey = "b9cfdbb42b402814a37567a6b7c40d3a"
    
    init(networkManager: NetworkManaging, apiService: APIServiceProtocol) {
        self.networkManager = networkManager
        self.apiService = apiService
    }
    
    func fetchCharacters(offset: Int, limit: Int, searchText: String) -> AnyPublisher<[CharacterListModel], Error> {
        guard var url = apiService.getCharactersURL(offset: offset, limit: limit, searchText: searchText) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if !searchText.isEmpty {
            let searchQueryItem = URLQueryItem(name: "name", value: searchText)
            urlComponents?.queryItems?.append(searchQueryItem)
        }
        guard let finalURL = urlComponents?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return networkManager.fetchData(from: finalURL, responseType: [CharacterListModel].self)
    }
    
    func generateMarvelHash() -> String {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let hashString = timestamp + privateKey + publicKey
        let hash = Insecure.MD5.hash(data: Data(hashString.utf8))
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
