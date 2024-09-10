//
//  PhotosListViewController + UISearchControllerDelegate.swift
//  ImageApp
//
//  Created by Egor Kruglov on 08.09.2024.
//

import UIKit

extension PhotosListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        interactor.getSavedQueries(filteredBy: nil)
        toggleViews(showPhotos: false)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        toggleViews(showPhotos: true)
    }
}
