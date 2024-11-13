//
//  CharacterListViewModel.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation
import Combine


class CharacterListViewModel: ObservableObject {
    
    private var networkManager: NetworkManaging
        private var cancellables = Set<AnyCancellable>()
        
        init(networkManager: NetworkManaging = NetworkManager(apiKey: "b9cfdbb42b402814a37567a6b7c40d3a")) {
            self.networkManager = networkManager
        }
        
        func fetchCharacters() {
            guard let url = URL(string: "https://api.marvel.com/v1/characters") else { return }
            
            networkManager.fetchData(from: url, responseType: CharacterListModel.self)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching data: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { response in
                    print("Received characters: \(response.data.results)")
            })
            .store(in: &cancellables)
        }
    }
