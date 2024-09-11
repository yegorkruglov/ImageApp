//
//  PhotosListInteractor.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

protocol PhotosListInteractorProtocol: ImageProviderProtocol {
    func viewDidLoad()
    func searchPhotosMatching(_ query: String)
    func saveSearchQuery(_ query: String)
    func getSavedQueries(filteredBy text: String?)
}

final class PhotosListInteractor: PhotosListInteractorProtocol {
    private let presentrer: PhotosListPresenterProtocol
    private let imageService: ImageServiceProtocol
    private let searchQueriesService: SearchQueriesServiceProtocol
    private var pageToDownload = 1
    
    init(
        presentrer: PhotosListPresenterProtocol,
        imageService: ImageServiceProtocol,
        searchQueriesService: SearchQueriesServiceProtocol
    ) {
        self.presentrer = presentrer
        self.imageService = imageService
        self.searchQueriesService = searchQueriesService
    }
    
    func viewDidLoad() {
        Task {
            do {
                let photos = try await imageService.showRandomPhotos()
                await presentrer.process(photos)
            } catch {
                await presentrer.process(error)
            }
        }
    }
    
    func searchPhotosMatching(_ query: String) {
        Task {
            do {
                let searchResult = try await imageService.searchPhotosMatching(query, page: pageToDownload)
                
                await presentrer.process(searchResult.results)
            } catch {
                await presentrer.process(error)
            }
        }
    }
    
    func saveSearchQuery(_ query: String) {
        searchQueriesService.saveQuery(query)
    }
    
    func getSavedQueries(filteredBy text: String?) {
        let queries = searchQueriesService.getSavedQueries()
        
        guard let text, !text.isEmpty else {
            presentrer.process(queries)
            return
        }
        
        presentrer.process(queries.filter { $0.lowercased().contains(text.lowercased()) } )
    }
}

extension PhotosListInteractor: ImageProviderProtocol {
    func loadImageFor(_ urlString: String) async throws -> Data {
        let imageData = try await imageService.loadImageFor(urlString)
        return imageData
    }
}
