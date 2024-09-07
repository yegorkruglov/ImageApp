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
        let photoListVC = PhotosListViewController()
        photoListVC.coordinator = self
        navigationController.pushViewController(photoListVC, animated: true)
    }
}
