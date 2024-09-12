//
//  ImageService.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation
protocol ImageServiceProtocol {
    func loadRandomPhotos() async throws -> [Photo]
    func loadImageFor(_ urlString: String) async throws -> Data
    func searchPhotosMatching(_ query: String?, page: Int) async throws -> SearchResult
}

final class ImageService: ImageServiceProtocol {
    private let api: PhotoApiProtocol
    private let storageService: StorageServiceProtocol
    
    init(api: PhotoApiProtocol, storageService: StorageServiceProtocol) {
        self.api = api
        self.storageService = storageService
    }
    
    func loadRandomPhotos() async throws -> [Photo] {
        try await api.getRandomPhotos()
    }
    func searchPhotosMatching(_ query: String?, page: Int) async throws -> SearchResult {
        try await api.searchPhotosMatching(query, page: page)
    }
    
    func loadImageFor(_ urlString: String) async throws -> Data {
        if let savedData = try storageService.loadDataFor(urlString) {
            return savedData
        }
        let imageData = try await api.loadImageDataFor(urlString)
        try storageService.save(imageData, for: urlString)
        return imageData
    }
}
