//
//  Encodable+JSON.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/12/21.
//

import Foundation
extension Encodable {
    func toJSONData(dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate, keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = dateEncodingStrategy
            encoder.keyEncodingStrategy = keyEncodingStrategy

            return try encoder.encode(self)
        } catch {
            return nil
        }
    }

    func toJSON(dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate, keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> [String: Any]? {
        guard let jsonData = self.toJSONData(dateEncodingStrategy: dateEncodingStrategy, keyEncodingStrategy: keyEncodingStrategy) else {
            return nil
        }

        do {
            return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
        } catch {
            return nil
        }
    }
}
