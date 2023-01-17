//
//  URLEncoder.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/13/21.
//

import Foundation

protocol URLEncodable {
    func encodeURL(path: String, iri: String?, pathSuffix: String?) throws -> URLRequest
}

extension URLEncodable {
    func encodeURL(path: String, iri: String?, pathSuffix: String? = nil) throws -> URLRequest {
        guard let iri = iri, let encoded = iri.encodeURL() else {
            throw NetworkError.encodingError
        }
        var urlString = "\(Constants.Network.baseURL)\(path)/\(encoded)"
        if let pathSuffix = pathSuffix {
            urlString += pathSuffix
        }
        guard let url = URL(string: urlString) else {
            throw NetworkError.encodingError
        }
        return URLRequest(url: url)
    }
}
