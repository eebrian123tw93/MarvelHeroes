//
//  CharacterListViewModel.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//

import Combine
import Foundation

class CharacterListViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let apiService: APIService!
    
    @Published private(set) var characters: [CharacterCell] = []
    private var offset: Int = 0
    private var loadMore: Bool = false
    
    init() {
        apiService = APIService()
        refresh()
    }
    
    func refresh() {
        offset = 0
        apiService.getCharacters()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
                print(type(of: error))
            }, receiveValue: { [unowned self] pagingData in
                offset = pagingData.nextOffset
                characters = pagingData.results.map {
                    CharacterCell(name: $0.name, description: $0.description, imageUrl: $0.thumbnail.url, aboutLink: $0.urls)
                }
            }).store(in: &cancellables)
    }
    
    func tryLoadMore(cell: CharacterCell) {
        guard !loadMore else { return }
        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
        if characters.firstIndex(where: { $0.id == cell.id }) == thresholdIndex {
            loadMore = true
            apiService.getCharacters(offset: offset)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [unowned self] error in
                    print(error)
                    print(type(of: error))
                    loadMore = false
                }, receiveValue: { [unowned self] pagingData in
                    offset = pagingData.nextOffset
                    let characters = pagingData.results.map {
                        CharacterCell(name: $0.name, description: $0.description, imageUrl: $0.thumbnail.url, aboutLink: $0.urls)
                    }
                    self.characters.append(contentsOf: characters)
                }).store(in: &cancellables)
            
        }
        
    }
}

