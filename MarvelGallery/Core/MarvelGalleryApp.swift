//
//  MarvelGalleryApp.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import SwiftUI

@main
struct MarvelGalleryApp: App {
    var body: some Scene {
        WindowGroup {
            CharacterListView(viewModel: createViewModel())
        }
    }
}

   func createViewModel() -> CharacterListViewModel {
        let networkManager = NetworkManager(apiKey: "")
        let marvelOperations = MarvelOperations(networkManager: networkManager, apiService: APIService())
        return CharacterListViewModel(operations: marvelOperations)
    }
