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
}
final class PhotosListPresenter: PhotosListPresenterProtocol {
    weak var viewController: PhotosListViewController?
    
    func process(_ photos: [Photo]) async {
        let snapshot = await prepareSnapshotForDisplay(from: photos)
        await viewController?.display(snapshot)
    }
    func process(_ error: Error) async {
        
    }
    private func prepareSnapshotForDisplay(from photos: [Photo]) async -> PhotosSnapshot {
        var snapshot = PhotosSnapshot.init()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        return snapshot
    }
}
