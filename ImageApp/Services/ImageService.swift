//
//  ImageService.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation
protocol ImageServiceProtocol {
    func showRandomPhotos() async throws -> [Photo]
    func loadImageFor(_ urlString: String) async throws -> Data
}

final class ImageService: ImageServiceProtocol {
    private let api: PhotoApiProtocol
    private let storageService: StorageServiceProtocol
    
    init(api: PhotoApiProtocol, storageService: StorageServiceProtocol) {
        self.api = api
        self.storageService = storageService
    }
    
    func showRandomPhotos() async throws -> [Photo] {
        try await api.getRandomPhotos()
    }
    
    func loadImageFor(_ urlString: String) async throws -> Data {
        if let savedData = storageService.loadDataFor(urlString) {
            return savedData
        }
        let imageData = try await api.loadImageDataFor(urlString)
        try storageService.save(imageData, for: urlString)
        return imageData
    }
}
