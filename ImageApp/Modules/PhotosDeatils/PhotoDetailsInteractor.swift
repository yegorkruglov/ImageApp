//
//  PhotoDetailsInteractor.swift
//  ImageApp
//
//  Created by Egor Kruglov on 11.09.2024.
//

import Foundation

protocol PhotoDetailsInteractorProtocol {
    func configureWith(_ photo: Photo)
}

final class PhotoDetailsInteractor: PhotoDetailsInteractorProtocol {
    private let presenter: PhotoDetailsPresenterProtocol
    private var photo: Photo?
    
    init(presenter: PhotoDetailsPresenterProtocol) {
        self.presenter = presenter
    }
    
    func configureWith(_ photo: Photo) {
        self.photo = photo
    }
}
