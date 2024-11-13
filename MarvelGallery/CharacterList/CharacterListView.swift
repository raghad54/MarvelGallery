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

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Header with Marvel Logo
                HStack {
                    Spacer()
                    Image("marvel_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 90)
                    Spacer()

                    Button(action: {
                        withAnimation {
                            isSearching.toggle()
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color.black)

                // Search Bar
                if isSearching {
                    HStack {
                        TextField("Search Characters", text: $searchText)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .frame(height: 40)

                        Button(action: {
                            withAnimation {
                                isSearching.toggle()
                                searchText = "" // Clear search text when closing
                                viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .top)) // Transition effect for search bar appearance
                }

                if viewModel.isLoading && !viewModel.isPaginating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        .scaleEffect(1.5)
                        .padding()
                }

                // Character List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.charactersList.filter {
                            searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
                        }) { character in
                            CharacterRowView(character: character)
                        }

                        // Pagination Loading Indicator
                        if viewModel.isPaginating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                .scaleEffect(1.5)
                                .padding()
                        }
                    }
                    .onAppear {
                        // Fetch the first batch of data when the view appears
                        if viewModel.charactersList.isEmpty {
                            viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                        }
                    }
                    .onChange(of: searchText) { _ in
                        // Reset and fetch new data when search text changes
                        viewModel.fetchCharacters(isPaginating: false, searchText: searchText)
                    }
                    .onReachBottom {
                        // Trigger pagination when the user reaches the bottom
                        if !viewModel.isPaginating && viewModel.hasMoreData {
                            viewModel.fetchCharacters(isPaginating: true, searchText: searchText)
                        }
                    }
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}
