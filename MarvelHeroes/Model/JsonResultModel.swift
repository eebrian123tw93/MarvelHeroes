//
//  JsonResultModel.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//

import Foundation

enum CustomError: Error {
    case invalidURL
    case responseNoData
    case payloadIsNotDictionary
    case payloadIsNil
    case resultIsNil
    case responseJsonParseFail
    case decodeError
}

struct JsonResultModel: Decodable {
    let code: Int
    let status: String
    let data: Any?
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        code = try container.decodeIfPresent(Int.self, forKey: .code) ?? 0
        if let dict = try container.decodeIfPresent([String: Any].self, forKey: .data) {
            data = dict
        } else if let array = try container.decodeIfPresent([Any].self, forKey: .data) {
            data = array
        } else {
            data = nil
        }
    }

    func dataDictionary()  throws -> [String: Any] {
        guard let result = self.data as? [String: Any] else {
            throw CustomError.payloadIsNotDictionary
        }
        return result
    }

    func mapTo<T: Decodable>(type: T.Type) throws -> T {
        guard let result = data else {
            throw CustomError.payloadIsNil
        }
        let data = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let model = try decoder.decode(type, from: data)
        return model
    }

}


public class DataPaging<T: Decodable>: NSObject, Decodable {

    var results: [T] = []
    var offset: Int = 0
    var count: Int = 0
    var total: Int = 0
    var limit: Int = 0
    
    var nextOffset: Int {
        offset + limit
    }

    enum CodingKeys: String, CodingKey {
        case results
        case offset
        case count
        case total
        case limit
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        results   = try container.decodeIfPresent( [T].self, forKey: .results ) ?? []
        offset = try container.decodeIfPresent(Int.self, forKey: .offset) ?? 0
        total = try container.decodeIfPresent(Int.self, forKey: .total) ?? 0
        count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
        limit = try container.decodeIfPresent(Int.self, forKey: .limit) ?? 0
    }

}

