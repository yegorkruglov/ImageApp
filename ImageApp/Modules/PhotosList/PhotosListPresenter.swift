//
//  PhotosListPresenter.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

protocol PhotosListPresenterProtocol {
    var viewController: PhotosListViewController? { get }
    func process(_ photos: [Photo]) async
    func process(_ error: Error) async
}
final class PhotosListPresenter: PhotosListPresenterProtocol {
    weak var viewController: PhotosListViewController?
    
    func process(_ photos: [Photo]) async {
        
    }
    func process(_ error: Error) async {
        
    }
}
