//
//  PhotosListPresenter.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import UIKit

protocol PhotosListPresenterProtocol {
    var viewController: PhotosListViewController? { get }
    func process(_ error: Error) async
    func process(_ savedQueries: [String])
    func process(_ photos: [Photo], isMorePhotosAvailable: Bool) async
}

final class PhotosListPresenter: PhotosListPresenterProtocol {
    weak var viewController: PhotosListViewController?
    
    func process(_ error: Error) async {
        
        let (title, description) = ErrorHandler.prepareAlertInfoFrom(error)
        await viewController?.displayErrorAlert(title, description)
    }
    
    func process(_ savedQueries: [String]) {
        Task {
            let snapshot = await prepareSnapshotForDisplay(from: savedQueries)
            await viewController?.display(snapshot)
        }
    }
    
    func process(_ photos: [Photo], isMorePhotosAvailable: Bool) async {
        let snapshot = await prepareSnapshotForDisplay(from: photos)
        await viewController?.display(snapshot, isMorePhotosAvailable: isMorePhotosAvailable)
    }
    
    private func prepareSnapshotForDisplay<Model: Hashable>(
        from items: [Model]
    ) async -> NSDiffableDataSourceSnapshot<PhotosListViewController.Sections, Model> {
        
        var snapshot = NSDiffableDataSourceSnapshot<PhotosListViewController.Sections, Model>.init()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        return snapshot
    }
}
