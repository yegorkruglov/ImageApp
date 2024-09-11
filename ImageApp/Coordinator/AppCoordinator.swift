//
//  AppCoordinator.swift
//  ImageApp
//
//  Created by Egor Kruglov on 07.09.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    var dependencies: Dependecies { get set }
    
    func start()
    func showPhotoList()
    func showPhotoDetailsFor(_ photo: Photo)
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var dependencies: Dependecies
    
    init(navigationController: UINavigationController, dependencies: Dependecies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showPhotoList()
    }
    
    func showPhotoList() {
        let photoListVC = PhotosListBuilder.build(dependecies: dependencies)
        photoListVC.coordinator = self
        
        navigationController.pushViewController(photoListVC, animated: true)
    }
    
    func showPhotoDetailsFor(_ photo: Photo) {
        let photoDetailsVC = PhotoDetailsBuilder.build(dependencies: dependencies)
        photoDetailsVC.coordinator = self
        photoDetailsVC.configureWith(photo)
        
        navigationController.pushViewController(photoDetailsVC, animated: true)
    }
}
