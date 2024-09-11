//
//  PhotoApi.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

protocol PhotoApiProtocol {
    func getRandomPhotos() async throws -> [Photo]
    func loadImageDataFor(_ urlString: String) async throws -> Data
    func searchPhotosMatching(_ query: String?, page: Int) async throws -> SearchResult
}

final class UnsplashApi: PhotoApiProtocol {
    private let networker: NetworkerProtocol
    private let baseUrl: String
    private let token: String
    
    init(networker: NetworkerProtocol, baseUrl: String, token: String) {
        self.networker = networker
        self.baseUrl = baseUrl
        self.token = token
    }
    
    func getRandomPhotos() async throws -> [Photo] {
        let urlRequest = try prepareUrlRequest(to: .loadRandomPhotos)
        let photos: [Photo] = try await networker.perfomRequest(urlRequest)
        return photos
    }
    
    func loadImageDataFor(_ urlString: String) async throws -> Data {
        let urlRequest = try prepareUrlRequest(to: .loadImageDataFrom(urlString))
        return try await networker.perfomRequest(urlRequest)
    }
    
    func searchPhotosMatching(_ query: String?, page: Int) async throws -> SearchResult {
        guard let query else { throw AppError.invalidQuery}
        let urlRequest = try prepareUrlRequest(to: .search(query, page))
        let searchResult: SearchResult = try await networker.perfomRequest(urlRequest)
        return searchResult
    }
    
    private func prepareUrlRequest(to request: UnsplashApi.Request) throws -> URLRequest {
        var urlString: String {
            switch request {
            case let .loadImageDataFrom(urlString):
                urlString
            default:
                baseUrl + request.endpoint
            }
        }
        var urlComponents = URLComponents(string: urlString)
        
        switch request {
        case .loadImageDataFrom(_):
            break
        default:
            urlComponents?.queryItems = request.parameters.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = urlComponents?.url else { throw NetworkError.invalidUrl }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        request.headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}

extension UnsplashApi {
    enum Request: Equatable {
        case loadRandomPhotos
        case loadImageDataFrom(String)
        case search(String, Int)
        
        var httpMethod: String { "GET" }
        
        var endpoint: String {
            switch self {
            case .loadRandomPhotos:
                "photos/random"
            case .search(_, _):
                "search/photos"
            case .loadImageDataFrom(_):
                String()
            }
        }
        
        var headers: [String: String] {
            switch self {
            case .loadRandomPhotos:
                [:]
            case .search(_, _), .loadImageDataFrom(_):
                [:]
            }
        }
        
        var parameters: [String: String] {
            switch self {
            case .loadRandomPhotos:
                ["count": "30"]
            case let .search(query, page):
                [
                    "query": "\(query)",
                    "per_page": "30",
                    "page": "\(page)"
                ]
            case .loadImageDataFrom(_):
                [:]
            }
        }
    }
}
