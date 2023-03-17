//
//  MarvelHeroesApp.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//

import SwiftUI

@main
struct MarvelHeroesApp: App {

    init() {
        #if DEBUG
        var injectionBundlePath = "/Applications/InjectionIII.app/Contents/Resources"
        #if targetEnvironment(macCatalyst)
        injectionBundlePath = "\(injectionBundlePath)/macOSInjection.bundle"
        #elseif os(iOS)
        injectionBundlePath = "\(injectionBundlePath)/iOSInjection.bundle"
        #endif
        Bundle(path: injectionBundlePath)?.load()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            CharacterListView()
        }
    }
}
