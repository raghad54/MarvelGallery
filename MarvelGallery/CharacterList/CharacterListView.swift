//
//  ContentView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import SwiftUI

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.characters, id: \.id) { character in
                       /* NavigationLink(destination: CharacterDetailView(viewModel: CharacterDetailViewModel(character: character)))*/ {
                            Text(character.name)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchCharacters()
            }
            .navigationTitle("Marvel Characters")
        }
    }
}

#Preview {
    CharacterListView(viewModel: CharacterListViewModel)
}
