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
        let networker = Networker(session: URLSession.shared, decoder: JSONDecoder())
        let api = UnsplashApi(
            networker: networker,
            baseUrl: "https://api.unsplash.com/",
            token: "zyXBhcA4JPT4gNCyFIMH3ioM-q0wUijpAowZHsrQ7HA"
        )
        let fileManager = FileManager.default
        let storageManger = StorageService(fileManager: fileManager)
        let imageService = ImageService(api: api, storageService: storageManger)
        let searchQueriesService = SearchQueriesService(
            searchKey: "searchQueries",
            maxQueries: 5,
            userDefaults: UserDefaults.standard
        )
        let interactor = PhotosListInteractor(
            presentrer: presenter,
            imageService: imageService,
            searchQueriesService: searchQueriesService
        )
        let viewController = PhotosListViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
