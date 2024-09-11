//
//  PhotosListViewController + UICollectionViewDelegate.swift
//  ImageApp
//
//  Created by Egor Kruglov on 08.09.2024.
//

import UIKit

extension PhotosListViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        let limit = UIScreen.main.bounds.height / 2
        
        guard
            offsetY > contentHeight - height - limit,
            !isFetchingMoreData
        else { return }
        
        isFetchingMoreData = true
        
        searchController.isActive
        ? interactor.loadMorePhotosFor(query: formattedQuery)
        : interactor.loadMoreRandomPhotos()
    }
}
