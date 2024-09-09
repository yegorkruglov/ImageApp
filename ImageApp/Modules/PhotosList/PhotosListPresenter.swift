//
//  PhotosListPresenter.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

protocol PhotosListPresenterProtocol {
    var viewController: PhotosListViewController? { get }
}
final class PhotosListPresenter: PhotosListPresenterProtocol {
    weak var viewController: PhotosListViewController?
}
