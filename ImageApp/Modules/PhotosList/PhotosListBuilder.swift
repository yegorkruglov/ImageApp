//
//  PhotosListBuilder.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

final class PhotosListBuilder {
    static func build() -> PhotosListViewController{
        let presenter = PhotosListPresenter()
        let interactor = PhotosListInteractor(presentrer: presenter)
        let viewController = PhotosListViewController(interactor: interactor)
        
        return viewController
    }
}
