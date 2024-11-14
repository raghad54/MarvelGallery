//
//  CharacterDetailView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: CharacterListModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                    .scaleEffect(2)
                    .padding()
            }

            ScrollView {
                VStack(spacing: 20) {
                    
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.horizontal)

                    AsyncImage(url: character.imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                            .edgesIgnoringSafeArea(.top)
                            .onAppear {
                                // When the image is loaded, hide the loading indicator
                                self.isLoading = false
                            }
                    } placeholder: {
                        Color.gray.frame(maxWidth: .infinity, maxHeight: 300)
                            .edgesIgnoringSafeArea(.top)
                            .onAppear {
                                // Show the loading indicator while loading
                                self.isLoading = true
                            }
                    }

                    // Character Name
                    CharacterInfoView(title: "Name", value: character.name)

                    // Character Description (Only show if description is not empty)
                    if !character.description.isEmpty {
                        CharacterDescriptionView(description: character.description)
                    }

                    // Sections for Comics, Series, Stories, Events
                    SectionView(title: "Comics", items: character.comics.items)
                    SectionView(title: "Series", items: character.series.items)
                    SectionView(title: "Stories", items: character.stories.items)
                    SectionView(title: "Events", items: character.events.items)

                    // Related Links Section
                    RelatedLinksView()

                }
            }
            .onAppear {
                isLoading = true
            }
            .navigationBarHidden(true)
        }
    }
}

struct CharacterInfoView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.red)
            Text(value)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

struct CharacterDescriptionView: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Description")
                .font(.system(size: 16))
                .foregroundColor(.red)
            Text(description)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

struct RelatedLinksView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Related Links")
                .font(.system(size: 16))
                .foregroundColor(.red)
                .padding(.horizontal)
                .padding(.top, 10)
            SectionWithArrowView(title: "Linked Details", action: {})
            SectionWithArrowView(title: "Wiki", action: {})
            SectionWithArrowView(title: "Comic Link", action: {})
        }
        .padding(.bottom, 20)
    }
}
