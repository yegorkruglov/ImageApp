//
//  Networker.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

protocol NetworkerProtocol {
    func perfomRequest(_ urlRequest: URLRequest) async throws -> Data
    func perfomRequest<Model: Codable>(_ urlRequest: URLRequest) async throws -> Model
}

final class Networker: NetworkerProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    @discardableResult
    func perfomRequest(_ urlRequest: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard (200...299).contains(response.statusCode) else { throw NetworkError.unexpectedStatusCode }
            return data
        } catch {
            throw error
        }
    }
    
    func perfomRequest<Model: Codable>(_ urlRequest: URLRequest) async throws -> Model {
        let data = try await perfomRequest(urlRequest)
        
        do {
            let decodedResponse = try decoder.decode(Model.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError
        }
    }
}
