    //
    //  CharacterListViewModel.swift
    //  MarvelGallery
    //
    //  Created by Raghad's Mac on 13/11/2024.
    //

import Foundation
import Combine

class CharacterListViewModel: ObservableObject {
    @Published var charactersList: [CharacterListModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isPaginating = false
    @Published var hasMoreData = true  // Tracks if there is more data to fetch

    private let operations: MarvelOperationsProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var offset = 0
    private let limit = 20
    private var isSearchActive = false  // To track if we are in search mode

    init(operations: MarvelOperationsProtocol) {
        self.operations = operations
    }

    func fetchCharacters(isPaginating: Bool = false, searchText: String = "") {
        if isPaginating {
            self.isPaginating = true
        } else {
            self.isLoading = true
        }

        // Check if we are searching, reset pagination and offset if so
        if !searchText.isEmpty && !isSearchActive {
            self.isSearchActive = true
            self.offset = 0  // Reset offset for new search
            self.charactersList.removeAll()  // Clear the list for new search
        }

        operations.fetchCharacters(offset: offset, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
                self.isPaginating = false
            }, receiveValue: { response in
                if response.count < self.limit {
                    self.hasMoreData = false  // No more data to fetch
                }

                // Append new data to the list
                self.charactersList += response
                self.offset += self.limit  // Increase offset by limit
            })
            .store(in: &cancellables)
    }
}
