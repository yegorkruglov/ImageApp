//
//  PhotosListViewController + UISearchBarDelegate.swift
//  ImageApp
//
//  Created by Egor Kruglov on 08.09.2024.
//

import UIKit

extension PhotosListViewController: UISearchBarDelegate {
    private var formattedText: String? {
        guard
            let text = searchController.searchBar.text,
            text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count >= 3
        else { return nil }
       
        return text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = formattedText else { return }
        interactor.saveSearchQuery(text)
        drainPhotosDataSource()
        interactor.searchPhotosMatching(text)
        
        toggleViews(showPhotos: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor.getSavedQueries(filteredBy: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        interactor.getSavedQueries(filteredBy: searchBar.text)
        toggleViews(showPhotos: false)
    }
}
