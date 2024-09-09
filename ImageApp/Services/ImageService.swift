//
//  ImageService.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation
protocol ImageServiceProtocol {
    func showRandomPhotos() async throws -> [Photo]
}

final class ImageService: ImageServiceProtocol {
    private let api: PhotoApiProtocol
    
    init(api: PhotoApiProtocol) {
        self.api = api
    }
    func showRandomPhotos() async throws -> [Photo] {
        try await api.getRandomPhotos()
    }
}
