//
//  ViewModel.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//

import Combine

class ViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let apiService: APIService!
    init() {
        apiService = APIService()
        apiService.getCaracters()
            .sink(receiveCompletion: { error in
            print(error)
            print(type(of: error))
        }, receiveValue: { pagingData in
            print(pagingData.results.count)
        }).store(in: &cancellables)
    }
}
