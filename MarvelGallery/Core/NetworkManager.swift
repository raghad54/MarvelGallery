//
//  NetworkManager.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation
import Combine

protocol NetworkManaging {
    func fetchData<T: Decodable>(url: URL, responseType: T.Type) -> AnyPublisher<T, Error>
}

class NetworkManager: NetworkManaging {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
