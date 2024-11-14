//
//  ContentView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import SwiftUI

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var isResultsVisible: Bool = true
    @State private var showNoResults: Bool = false
    @State private var debounceTimer: Timer?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        if !isSearching {
                            Spacer()
                            Image("marvel_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 90)
                            Spacer()
                        } else {
                            TextField("Search Characters", text: $searchText)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .frame(height: 40)
                                .padding(.horizontal)
                        }

                        Button(action: {
                            withAnimation {
                                isSearching.toggle()
                                if !isSearching {
                                    searchText = ""
                                    isResultsVisible = true
                                    showNoResults = false
                                    viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                                } else {
                                    viewModel.charactersList = []
                                    isResultsVisible = false
                                    showNoResults = false
                                    viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                                }
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal) 
                    .background(Color.black)
                    .zIndex(1)
                }

                ScrollView {
                    LazyVStack(spacing: 0) {
                        if viewModel.isLoading && !viewModel.isPaginating && !isSearching {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                .scaleEffect(1.5)
                                .padding()
                        }

                        if showNoResults && searchText.isEmpty == false {
                            Text("No results found.")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }

                        if isResultsVisible {
                            ForEach(viewModel.getCharactersToDisplay()) { character in
                                NavigationLink(destination: CharacterDetailView(character: character)) {
                                    CharacterRowView(character: character)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            if viewModel.isPaginating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                    .scaleEffect(1.5)
                                    .padding()
                            }
                        }
                    }
                    .onAppear {
                        if viewModel.charactersList.isEmpty {
                            viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                        }
                    }
                    .onChange(of: searchText) { newValue in
                        debounceTimer?.invalidate()

                        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                            showNoResults = false
                            viewModel.fetchCharacters(isPaginating: false, searchText: newValue)
                        }
                    }
                    .onReachBottom {
                        if !viewModel.isPaginating && viewModel.hasMoreData {
                            viewModel.fetchCharacters(isPaginating: true, searchText: searchText)
                        }
                    }
                    .refreshable {
                        viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                    }
                    .background(Color.black)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}
