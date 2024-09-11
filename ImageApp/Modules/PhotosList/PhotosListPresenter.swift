//
//  PhotosListPresenter.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import UIKit

protocol PhotosListPresenterProtocol {
    var viewController: PhotosListViewController? { get }
    func process(_ photos: [Photo], morePhotosAvailable: Bool) async 
    func process(_ error: Error) async
    func process(_ savedQueries: [String])
    
    
    func process(_ photos: [Photo], to dataSource: DataSource, isMoreAvailable: Bool) async
}

final class PhotosListPresenter: PhotosListPresenterProtocol {
    weak var viewController: PhotosListViewController?
    
    func process(_ photos: [Photo], morePhotosAvailable: Bool) async {
        let snapshot = await prepareSnapshotForDisplay(from: photos)
        await viewController?.display(snapshot, morePhotosAvailable: morePhotosAvailable)
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
    
    func process(_ photos: [Photo], to dataSource: DataSource, isMoreAvailable: Bool) async {
        switch dataSource {
            
        case .new:
            let snapshot = await prepareSnapshotForDisplay(from: photos)
            await viewController?.display(snapshot, morePhotosAvailable: isMoreAvailable)
            
        case .existing:
            guard
                let currentDatasource = await viewController?.photosCollectionView.dataSource
                    as? NSDiffableDataSourceSnapshot<PhotosListViewController.Sections, Photo>
            else { return }
            
            let currentPhotos = currentDatasource.itemIdentifiers(inSection: .main)
            let mergedPhotos = photos.reduce(into: currentPhotos) { !$0.contains($1) ? $0.append($1) : () }
            
            let snapshot = await prepareSnapshotForDisplay(from: mergedPhotos)
            await viewController?.display(snapshot, morePhotosAvailable: isMoreAvailable)
        }
    }
}
