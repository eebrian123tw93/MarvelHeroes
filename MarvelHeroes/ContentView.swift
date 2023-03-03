//
//  ContentView.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//

import SwiftUI

struct ContentView: View {
    @State var list:[Int] = []
    let viewModel = ViewModel()
    var body: some View {
        CustomText()
    }
}

struct CustomText: View {
    var body: some View {
        Text("Hello")
            .font(.body)
            .fontWeight(.bold)
            .foregroundColor(Color.red)
            .multilineTextAlignment(.center)
            .padding([.top, .leading, .trailing])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
