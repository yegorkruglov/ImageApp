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
    func showPhotoList()
    func showPhotoDetailsFor(_ photo: Photo)
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
        let photoListVC = PhotosListBuilder.build()
        photoListVC.coordinator = self
        
        navigationController.pushViewController(photoListVC, animated: true)
    }
    
    func showPhotoDetailsFor(_ photo: Photo) {
        let photoDetailsVC = PhotoDetailsBuilder.build()
        photoDetailsVC.coordinator = self
        photoDetailsVC.configureWith(photo)
        
        navigationController.pushViewController(photoDetailsVC, animated: true)
    }
}
