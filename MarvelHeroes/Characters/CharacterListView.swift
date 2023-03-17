//
//  ContentView.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//

import SwiftUI

struct CharacterListView: View {
    @ObservedObject var viewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.characters, id: \.id) { cell in
                NavigationLink(destination: CharactersDetailView(cell: cell), label: {
                    CustomCell(cell: cell).onAppear {
                        viewModel.tryLoadMore(cell: cell)
                    }
                })
    
            }.listStyle(.grouped)
            .navigationTitle("Marvel Characters")
            .refreshable {
                viewModel.refresh()
            }
        }
        
    }
}

struct CustomCell: View {
    @State var cell: CharacterCell
    var body: some View {
        HStack {
            AsyncImage(url: cell.imageUrl) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.purple.opacity(0.1)
            }.scaledToFit()
                .frame(width:80, height: 80)
                .cornerRadius(8)
                .padding(.vertical, 2)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(cell.name)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                Text(cell.description)
                    .lineLimit(2)
            }.padding(.vertical, 8)
            
            Spacer()
        }
    }
}

struct CharacterCell: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageUrl: URL?
    let aboutLink: [AboutLink]
}



#if DEBUG
class ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
    #if DEBUG
    @objc class func injected() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController =
                UIHostingController(rootView: CharacterListView())
    }
    #endif
}
#endif
