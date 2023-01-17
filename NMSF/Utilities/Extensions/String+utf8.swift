//
//  String+utf8.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/13/21.
//

import Foundation
extension String {
    func encodeUTF() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }

    func decodeUTF() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }

    func encodeURL() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
    }
}
