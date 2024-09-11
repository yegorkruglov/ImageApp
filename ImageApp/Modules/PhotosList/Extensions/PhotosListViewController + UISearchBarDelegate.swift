//
//  PhotosListViewController + UISearchBarDelegate.swift
//  ImageApp
//
//  Created by Egor Kruglov on 08.09.2024.
//

import UIKit

extension PhotosListViewController: UISearchBarDelegate {
    var formattedQuery: String? {
        guard
            let text = searchController.searchBar.text,
            text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count >= 3
        else { return nil }
       
        return text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = formattedQuery else { return }
        interactor.saveSearchQuery(text)
        drainPhotosDataSource()
        interactor.loadMorePhotosFor(query: text)
        
        toggleViews(showPhotos: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        drainPhotosDataSource()
        toggleViews(showPhotos: true)
        interactor.reloadRandoms()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor.getSavedQueries(filteredBy: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        interactor.getSavedQueries(filteredBy: searchBar.text)
        toggleViews(showPhotos: false)
    }
}
