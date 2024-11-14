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
    @Published var filteredCharacters: [CharacterListModel] = [] 
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isPaginating = false
    @Published var hasMoreData = true

    private let operations: MarvelOperationsProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var offset = 0
    private let limit = 20
    private var isSearchActive = false
    private var currentSearchText = ""

    init(operations: MarvelOperationsProtocol) {
        self.operations = operations
    }

    func fetchCharacters(isPaginating: Bool = false, searchText: String = "") {
        guard !isLoading, !isPaginating || hasMoreData else { return }

        if isPaginating {
            self.isPaginating = true
        } else {
            self.isLoading = true
            self.offset = 0
        }

        if searchText != currentSearchText {
            isSearchActive = true
            currentSearchText = searchText
            offset = 0
            charactersList.removeAll()
            hasMoreData = true
        }

        operations.fetchCharacters(offset: offset, limit: limit, searchText: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.hasMoreData = false
                }
                self.isLoading = false
                self.isPaginating = false
            }, receiveValue: { response in
                if response.count < self.limit {
                    self.hasMoreData = false
                }
                if response.count > 0 {
                    self.offset += self.limit
                    self.charactersList += response
                }

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

    func getCharactersToDisplay() -> [CharacterListModel] {
        return isSearchActive && !filteredCharacters.isEmpty ? filteredCharacters : charactersList
    }
}
