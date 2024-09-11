//
//  PhotosListBuilder.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

enum PhotosListBuilder {
    static func build(dependecies: Dependecies) -> PhotosListViewController{
        let presenter = PhotosListPresenter()
        let interactor = PhotosListInteractor(
            presentrer: presenter,
            imageService: dependecies.imageService,
            searchQueriesService: dependecies.searchQueriesService
        )
        let viewController = PhotosListViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
