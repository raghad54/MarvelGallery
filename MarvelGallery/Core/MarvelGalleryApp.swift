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
        let networkManager = NetworkManager(apiKey: "b9cfdbb42b402814a37567a6b7c40d3a")
        let marvelOperations = MarvelOperations(networkManager: networkManager, apiService: APIService())
        return CharacterListViewModel(operations: marvelOperations)
    }
