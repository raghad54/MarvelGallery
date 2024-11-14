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
                                    searchText = "" // Clear search text when closing
                                    isResultsVisible = true // Show table again when search is closed
                                    showNoResults = false
                                    viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                                } else {
                                    // Clear character list to show empty state when search is activated
                                    viewModel.charactersList = []
                                    isResultsVisible = false // Hide table when search is activated
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
                    .padding()
                    .background(Color.black)
                    .zIndex(1)
                }

                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Show Loading Indicator at the top while fetching characters
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

                        // Show characters if results are visible
                        if isResultsVisible {
                            ForEach(viewModel.getCharactersToDisplay()) { character in
                                // NavigationLink for character detail view
                                NavigationLink(destination: CharacterDetailView(character: character)) {
                                    CharacterRowView(character: character)
                                }
                                .buttonStyle(PlainButtonStyle()) // Prevent row highlight on tap
                            }

                            // Pagination Loading Indicator
                            if viewModel.isPaginating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .red)) // Red color for pagination indicator
                                    .scaleEffect(1.5)
                                    .padding()
                            }
                        }
                    }
                    .onAppear {
                        // Fetch the first batch of data when the view appears
                        if viewModel.charactersList.isEmpty {
                            viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                        }
                    }
                    .onChange(of: searchText) { newValue in
                        // Cancel previous timer if any
                        debounceTimer?.invalidate()

                        // Start a new debounce timer
                        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                            // Reset and fetch new data when search text changes
                            showNoResults = false // Hide no results message while loading
                            viewModel.fetchCharacters(isPaginating: false, searchText: newValue)
                        }
                    }
                    .onReachBottom {
                        // Trigger pagination when the user reaches the bottom
                        if !viewModel.isPaginating && viewModel.hasMoreData {
                            viewModel.fetchCharacters(isPaginating: true, searchText: searchText)
                        }
                    }
                    .refreshable {
                        viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                    }
                    .background(Color.black) // Set the background of the ScrollView to black
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Background for the whole view
        }
    }
}
