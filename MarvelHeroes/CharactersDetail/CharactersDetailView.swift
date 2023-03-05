//
//  CharactersDetailView.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/5.
//

import SwiftUI

struct CharactersDetailView: View {
    let cell: CaracterCell
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
            List(cell.abountLink, id: \.url) { abountLink in
                Link(destination: URL(string: abountLink.url)!, label: {
                    Text(abountLink.type.rawValue)
                })
            }.listStyle(.plain)

            
            Spacer()
        }
    }
}

struct CaractersDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersDetailView(cell: .init(name: "Main", description: "dfhakjldfh", imageUrl: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"), abountLink: []))
    }
}
