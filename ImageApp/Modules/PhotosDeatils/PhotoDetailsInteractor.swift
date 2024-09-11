//
//  PhotoDetailsInteractor.swift
//  ImageApp
//
//  Created by Egor Kruglov on 11.09.2024.
//

import Foundation

protocol PhotoDetailsInteractorProtocol {
    func configureWith(_ photo: Photo)
    func loadImage()
}

final class PhotoDetailsInteractor: PhotoDetailsInteractorProtocol, ImageProviderProtocol {
    
    
    private let presenter: PhotoDetailsPresenterProtocol
    private let imageService: ImageServiceProtocol
    private var photo: Photo?
    
    init(presenter: PhotoDetailsPresenterProtocol, imageService: ImageServiceProtocol) {
        self.presenter = presenter
        self.imageService = imageService
    }
    
    func configureWith(_ photo: Photo) {
        self.photo = photo
    }
    
    func loadImage() {
        guard let urlString = photo?.urls.full else { return }
        
        Task {
            do {
                
                let imageData = try await loadImageFor(urlString)
                await presenter.process(imageData)
            } catch {
                await presenter.process(error)
            }
        }
    }
    
    func loadImageFor(_ urlString: String) async throws -> Data {
        try await imageService.loadImageFor(urlString)
    }
}
