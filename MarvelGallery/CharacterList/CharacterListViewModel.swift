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
    @Published var filteredCharacters: [CharacterListModel] = [] // Store filtered characters for search
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isPaginating = false
    @Published var hasMoreData = true

    private let operations: MarvelOperationsProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var offset = 0
    private let limit = 20
    private var isSearchActive = false  // Tracks if we are in search mode
    private var currentSearchText = ""

    init(operations: MarvelOperationsProtocol) {
        self.operations = operations
    }

    // Fetch Characters Function with Updated Logic
    func fetchCharacters(isPaginating: Bool = false, searchText: String = "") {
        // Prevent duplicate fetching
        guard !isLoading, !isPaginating || hasMoreData else { return }

        if isPaginating {
            self.isPaginating = true
        } else {
            self.isLoading = true
            self.offset = 0 // Reset offset if it's a fresh fetch
        }

        // Check if search mode is active and reset if necessary
        if searchText != currentSearchText {
            isSearchActive = true
            currentSearchText = searchText
            offset = 0 // Reset offset for a new search
            charactersList.removeAll() // Clear current list for new search results
            hasMoreData = true // Reset pagination state
        }

        // If searchText is not empty, we will pass it as a parameter for filtering the characters
        operations.fetchCharacters(offset: offset, limit: limit, searchText: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.hasMoreData = false // Stop further requests if there's an error
                }
                self.isLoading = false
                self.isPaginating = false
            }, receiveValue: { response in
                // If the received data count is less than the limit, no more pages to fetch
                if response.count < self.limit {
                    self.hasMoreData = false
                }
                // Update offset only if new data is fetched
                if response.count > 0 {
                    self.offset += self.limit
                    self.charactersList += response
                }

                // If search is active, filter the characters by name
                if !searchText.isEmpty {
                    self.filteredCharacters = self.charactersList.filter {
                        $0.name.lowercased().contains(searchText.lowercased())
                    }
                } else {
                    self.filteredCharacters = self.charactersList
                }
            })
            .store(in: &cancellables)
    }

    // This method is used to get the final list of characters to display
    func getCharactersToDisplay() -> [CharacterListModel] {
        return isSearchActive && !filteredCharacters.isEmpty ? filteredCharacters : charactersList
    }
}
