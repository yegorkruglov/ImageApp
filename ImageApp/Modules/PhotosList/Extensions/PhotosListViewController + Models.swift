//
//  PhotosListViewController + Models.swift
//  ImageApp
//
//  Created by Egor Kruglov on 10.09.2024.
//

import UIKit

typealias DataSource = PhotosListViewController.DataSource
typealias PhotosSnapshot = NSDiffableDataSourceSnapshot<PhotosListViewController.Sections, Photo>
typealias QueriesSnapshot = NSDiffableDataSourceSnapshot<PhotosListViewController.Sections, String>

extension PhotosListViewController {
    enum Sections {
        case main
    }
    
    enum DataSource {
        case new
        case existing
    }
}
