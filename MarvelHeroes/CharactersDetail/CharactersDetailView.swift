//
//  CharactersDetailView.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/5.
//

import SwiftUI

struct CharactersDetailView: View {
    let cell: CharacterCell
    var body: some View {
        VStack {

            AsyncImage(url: cell.imageUrl) { image in
                image.resizable()
            } placeholder: {
                Color.purple.opacity(0.1)
            }.scaledToFit()
                .frame(height: 200)
                .cornerRadius(8)
                .padding(.vertical, 2)
            
            Text(cell.name)
                .fontWeight(.bold)
            Spacer()
                .frame(height: 16)
            Text(cell.description)
                .padding(.horizontal, 16)
            Divider()
            List(cell.aboutLink, id: \.url) { aboutLink in
                Link(destination: URL(string: aboutLink.url)!, label: {
                    Text(aboutLink.type.rawValue)
                })
            }.listStyle(.plain)

            
            Spacer()
        }
    }
}

class CharactersDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersDetailView(cell: .init(name: "Main", description: "dfha2kjldfh", imageUrl: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"), aboutLink: []))
    }
    #if DEBUG
    @objc class func injected() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController =
                UIHostingController(rootView: CharactersDetailView_Previews.previews)
    }
    #endif
}
