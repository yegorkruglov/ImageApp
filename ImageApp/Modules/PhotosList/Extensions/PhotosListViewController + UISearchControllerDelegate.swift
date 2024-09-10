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
        UIView.animate(withDuration: 0.3) {
            self.photosCollectionView.alpha = 0
            self.searchSuggestionsTableView.alpha = 1
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.3) {
            self.photosCollectionView.alpha = 1
            self.searchSuggestionsTableView.alpha = 0
        }
    }
}
