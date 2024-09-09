//
//  AppCoordinator.swift
//  ImageApp
//
//  Created by Egor Kruglov on 07.09.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showPhotoList()
    }
    
    func showPhotoList() {
        let searchQueriesService = SearchQueriesService(
            searchKey: "recentSearches",
            maxQueries: 5,
            userDefaults: UserDefaults.standard
        )
        
        let input = PhotosListViewController.Input(
            coordinator: self,
            searchQueriesService: searchQueriesService
        )
        
        let photoListVC = PhotosListBuilder.build()
        
        navigationController.pushViewController(photoListVC, animated: true)
    }
}
