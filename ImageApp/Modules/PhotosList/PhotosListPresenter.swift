//
//  PhotosListPresenter.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import UIKit

protocol PhotosListPresenterProtocol {
    var viewController: PhotosListViewController? { get }
    func process(_ photos: [Photo]) async
    func process(_ error: Error) async
    func process(_ savedQueries: [String])
}

final class PhotosListPresenter: PhotosListPresenterProtocol {
    weak var viewController: PhotosListViewController?
    
    func process(_ photos: [Photo]) async {
        let snapshot = await prepareSnapshotForDisplay(from: photos)
        await viewController?.display(snapshot)
    }
    
    func process(_ savedQueries: [String]) {
        Task {
            let snapshot = await prepareSnapshotForDisplay(from: savedQueries)
            await viewController?.display(snapshot)
        }
    }
    
    func process(_ error: Error) async {
        
    }
    
    private func prepareSnapshotForDisplay<Model: Hashable>(
        from photos: [Model]
    ) async -> NSDiffableDataSourceSnapshot<PhotosListViewController.Sections, Model> {
        var snapshot = NSDiffableDataSourceSnapshot<PhotosListViewController.Sections, Model>.init()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        return snapshot
    }
}
