//
//  PhotosListViewController + UISearchBarDelegate.swift
//  ImageApp
//
//  Created by Egor Kruglov on 08.09.2024.
//

import UIKit

extension PhotosListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard 
            let text = searchBar.text,
            !text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
        else { return }
        
        interactor.saveSearchQuery(text)
        drainPhotosDataSource()
        interactor.searchPhotosMatching(text)
        
        toggleViews(showPhotos: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor.getSavedQueries(filteredBy: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        toggleViews(showPhotos: false)
    }
}
