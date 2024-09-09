//
//  PhotosListInteractor.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation
protocol PhotosListInteractorProtocol {
    
}
final class PhotosListInteractor: PhotosListInteractorProtocol {
    private let presentrer: PhotosListPresenterProtocol
    
    init(presentrer: PhotosListPresenterProtocol) {
        self.presentrer = presentrer
    }
}
