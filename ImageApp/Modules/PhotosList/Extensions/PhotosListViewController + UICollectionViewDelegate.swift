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
}
