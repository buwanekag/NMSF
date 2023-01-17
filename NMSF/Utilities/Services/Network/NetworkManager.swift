//
//  NetworkManager.swift
//  NMSF
//
//  Created by Matt Stanford on 5/21/21.
//

import Combine
import Foundation

class NetworkManager {
    private let networkTimeout = 60.0
    private let session: URLSession
    
    typealias APIResponse = URLSession.DataTaskPublisher.Output
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = networkTimeout
        sessionConfig.timeoutIntervalForResource = networkTimeout

        self.session = URLSession(configuration: sessionConfig)
    }
    
    func call<T: Decodable>(payloadType: T.Type, endpoint: ApiEndpoint) -> AnyPublisher<T, Error> {
        
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        
        //This app only retrieves data
        let method = "GET"
        
        let urlRequest = getUrlRequest(endpoint: endpoint, method: method, headers: headers)

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { result -> T in
                if let error = try self.getApiError(from: result) {
                    throw error
                }

                return try self.decodeJsonResponse(data: result.data)
            }
            .eraseToAnyPublisher()
        
    }
    
    private func getUrlRequest(endpoint: ApiEndpoint, method: String, headers: [String: String]) -> URLRequest {

        let url = getUrlWithQueryParams(endpoint: endpoint)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        return urlRequest
    }
    
    private func getUrlWithQueryParams(endpoint: ApiEndpoint) -> URL {
        let url = URL(string: endpoint.path)!

        let finalUrl: URL
        if let queryParams = endpoint.queryParams {

            var urlComponents = URLComponents(string: url.absoluteString)
            urlComponents?.queryItems = queryParams.map({ URLQueryItem(name: $0, value: $1) })

            let adjustedUrl = urlComponents!.url
            finalUrl = adjustedUrl!
        } else {
            finalUrl = url
        }

        return finalUrl
    }
    
    private func getApiError(from result: APIResponse) throws -> ApiError? {
        guard let response = result.response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if response.statusCode < 200 || response.statusCode >= 300 {
            return ApiError.httpError(code: response.statusCode)
        } else {
            return nil
        }
    }
    
    private func decodeJsonResponse<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(T.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            throw ApiError.decodingError
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw ApiError.decodingError
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw ApiError.decodingError
        } catch let DecodingError.typeMismatch(type, context)  {
            print(String(data: data, encoding: .utf8)!)
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw ApiError.decodingError
        } catch {
            print("error: ", error)
            throw ApiError.decodingError
        }
    }
}
