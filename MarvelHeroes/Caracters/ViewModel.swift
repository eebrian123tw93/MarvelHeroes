//
//  ViewModel.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//

import Combine
import Foundation

class ViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let apiService: APIService!
    
    @Published private(set) var characters: [CaracterCell] = []
    private var offset: Int = 0
    private var loadMore: Bool = false
    
    init() {
        apiService = APIService()
        refesh()
    }
    
    func refesh() {
        offset = 0
        apiService.getCaracters()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
                print(type(of: error))
            }, receiveValue: { [unowned self] pagingData in
                self.offset = pagingData.offset + pagingData.limit
                self.characters = pagingData.results.map {
                    let imageUrlString = "\($0.thumbnail.path.replacingOccurrences(of: "http://", with: "https://")).\($0.thumbnail.thumbnailExtension)"
                    let imageUrl = URL(string: imageUrlString)
                    return CaracterCell(name: $0.name, description: $0.description, imageUrl: imageUrl)
                }
            }).store(in: &cancellables)
    }
    
    func tryLoadMore(cell: CaracterCell) {
        guard !loadMore else { return }
        print("loadMore")
        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
        if characters.firstIndex(where: { $0.id == cell.id }) == thresholdIndex {
            loadMore = true
            apiService.getCaracters(offset: offset)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [unowned self] error in
                    print(error)
                    print(type(of: error))
                    self.loadMore = false
                }, receiveValue: { [unowned self] pagingData in
                    print(pagingData.results.count)
                    self.offset = pagingData.offset + pagingData.limit
                    let characters = pagingData.results.map {
                        let imageUrlString = "\($0.thumbnail.path.replacingOccurrences(of: "http://", with: "https://")).\($0.thumbnail.thumbnailExtension)"
                        let imageUrl = URL(string: imageUrlString)
                        return CaracterCell(name: $0.name, description: $0.description, imageUrl: imageUrl)
                    }
                    self.characters.append(contentsOf: characters)
                }).store(in: &cancellables)
            
        }
        
    }
}

