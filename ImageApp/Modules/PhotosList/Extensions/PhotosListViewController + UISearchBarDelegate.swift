//
//  PhotosListViewController + UISearchBarDelegate.swift
//  ImageApp
//
//  Created by Egor Kruglov on 08.09.2024.
//

import UIKit

extension PhotosListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty else { return }
        
        self.searchQueriesService.saveQuery(text)
        
        // network job
        
        self.searchController.isActive = false
    }
}
