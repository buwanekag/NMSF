//
//  JsonIdentifiable.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/13/21.
//

import Foundation

protocol JsonIdentfiable: Codable {
    var id: String { get }
}

protocol JsonModelable: JsonIdentfiable {
    associatedtype EntityType: Codable

    var id: String { get }

    func createJsonPayload() -> EntityType
}

extension JsonModelable {
    static func createJsonData<T: Decodable & JsonModelable> (_ payload: T) throws -> Data {
        let dataPayload = payload.createJsonPayload()

        let jsonRequest = JsonRequest(data: dataPayload)
        guard let jsonData = try? Coder.encode(jsonRequest) else {
            throw NetworkError.encodingError
        }
        return jsonData
    }
}

struct LinkData: Codable {
    let id: String
}

struct JsonResourceLink: Codable {

    let data: LinkData?

    init<T: JsonIdentfiable>(resource: T) {
        self.data = LinkData(id: resource.id)
    }

    init?(withId id: String?) {
        if let id = id {
            self.data = LinkData(id: id)
            return
        }
        return nil
    }

    //use this initializer for cases when you want the data object to be null once encoded
    init(id: String?) {
        if let id = id {
            self.data = LinkData(id: id)
            return
        } else {
            self.data = nil
            return
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
    }
}

struct JsonResourceLinkArray: Codable {
    let data: [LinkData]

    init<T: JsonIdentfiable>(resources: [T]) {
        self.data = resources.map { LinkData(id: $0.id) }
    }

    init?(withIds ids: [String]?) {
        if let ids = ids {
            self.data = ids.map { LinkData(id: $0) }
            return
        }
        return nil
    }

    init?<T: JsonIdentfiable>(_ resource: [T]?) {
        if let resource = resource {
            self.data = resource.map { LinkData(id: $0.id) }
            return
        }
        return nil
    }
}
