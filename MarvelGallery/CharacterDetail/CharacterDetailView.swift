//
//  CharacterDetailView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import SwiftUI

struct CharacterHeaderView: View {
    let character: CharacterListModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true

    var body: some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: character.imageUrl) { phase in
                switch phase {
                case .empty:
                    Color.gray.frame(maxWidth: .infinity, maxHeight: 300)
                        .edgesIgnoringSafeArea(.top)
                        .onAppear {
                            self.isLoading = true // Set loading state to true when image is empty
                        }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .clipped()
                        .edgesIgnoringSafeArea(.top)
                        .onAppear {
                            self.isLoading = false // Set loading state to false when image is successfully loaded
                        }
                case .failure:
                    Color.red.frame(maxWidth: .infinity, maxHeight: 300)
                        .edgesIgnoringSafeArea(.top)
                        .onAppear {
                            self.isLoading = false // Set loading state to false when image loading fails
                        }
                @unknown default:
                    EmptyView()
                }
            }
            
            // Small Progress Indicator on Image
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding()
            }

            // Back Button Layer
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
            .padding(.leading, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
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

struct CharacterDetailView: View {
    let character: CharacterListModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    CharacterHeaderView(character: character)
                    CharacterInfoView(title: "Name", value: character.name)

                    if !character.description.isEmpty {
                        CharacterDescriptionView(description: character.description)
                    }

                    SectionView(title: "Comics", items: character.comics.items)
                    SectionView(title: "Series", items: character.series.items)
                    SectionView(title: "Stories", items: character.stories.items)
                    SectionView(title: "Events", items: character.events.items)
                    RelatedLinksView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
