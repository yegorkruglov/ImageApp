//
//  PhotosListInteractor.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation
protocol PhotosListInteractorProtocol {
    func viewDidLoad()
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
}
