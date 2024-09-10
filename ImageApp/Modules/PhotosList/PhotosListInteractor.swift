//
//  PhotosListInteractor.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation
protocol PhotosListInteractorProtocol {
    func viewDidLoad()
    func loadImageFor(_ urlString: String) async throws -> Data
}
final class PhotosListInteractor: PhotosListInteractorProtocol {
    private let presentrer: PhotosListPresenterProtocol
    private let imageService: ImageServiceProtocol
    
    internal init(presentrer: any PhotosListPresenterProtocol, imageService: any ImageServiceProtocol) {
        self.presentrer = presentrer
        self.imageService = imageService
    }
    
    func viewDidLoad() {
        Task {
            do {
                let photos = try await imageService.showRandomPhotos()
                await presentrer.process(photos)
            } catch {
                await presentrer.process(error)
            }
        }
    }
    
    func loadImageFor(_ urlString: String) async throws -> Data {
        let imageData = try await imageService.loadImageFor(urlString)
        return imageData
    }
}
