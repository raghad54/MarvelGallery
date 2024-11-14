//
//  LinksDetailsSection.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 14/11/2024.
//

import SwiftUI

struct SectionWithArrowView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top)
        .onTapGesture {
            action()
        }
    }
}
