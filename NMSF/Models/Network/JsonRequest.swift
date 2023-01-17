//
//  JsonRequest.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/13/21.
//

import Foundation

struct JsonRequest<T: Codable>: Codable {
    let data: T
    let meta: JSON?

    init(data: T) {
        self.data = data
        self.meta = nil
    }

    init(data: T, meta: JSON?) {
        self.data = data
        self.meta = meta
    }
}
