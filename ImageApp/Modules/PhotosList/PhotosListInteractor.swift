//
//  PhotosListInteractor.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

protocol PhotosListInteractorProtocol: ImageProviderProtocol {
    func saveSearchQuery(_ query: String)
    func getSavedQueries(filteredBy text: String?)
    func loadMoreRandomPhotos()
    func loadMorePhotosFor(query: String?)
}

final class PhotosListInteractor: PhotosListInteractorProtocol {
    private let presentrer: PhotosListPresenterProtocol
    private let imageService: ImageServiceProtocol
    private let searchQueriesService: SearchQueriesServiceProtocol
    
    private var randomPhotos: [Photo] = []
    private var queryPhotos: [Photo] = []
    
    private var lastQuery: String?
    private var pageToDownload: Int = 1
    private var totalPages: Int?
    
    init(
        presentrer: PhotosListPresenterProtocol,
        imageService: ImageServiceProtocol,
        searchQueriesService: SearchQueriesServiceProtocol
    ) {
        self.presentrer = presentrer
        self.imageService = imageService
        self.searchQueriesService = searchQueriesService
    }
    
    // MARK: -  queries
    
    func saveSearchQuery(_ query: String) {
        searchQueriesService.saveQuery(query)
    }
    
    func getSavedQueries(filteredBy text: String?) {
        let queries = searchQueriesService.getSavedQueries()
        
        guard let text, !text.isEmpty else {
            presentrer.process(queries)
            return
        }
        
        presentrer.process(queries.filter { $0.lowercased().contains(text.lowercased()) })
    }
    
    // MARK: - photos load
    
    func loadMoreRandomPhotos() {
        Task {
            do {
                let photos = try await imageService.loadRandomPhotos()
                await MainActor.run {
                    for photo in photos {
                        if !randomPhotos.contains(photo) { randomPhotos.append(photo) }
                    }
                }
                await presentrer.process(randomPhotos, isMorePhotosAvailable: true)
            } catch {
                await presentrer.process(error)
            }
        }
    }
    
    func loadMorePhotosFor(query: String?) {
        guard let query else { return }
        
        if lastQuery != query {
            lastQuery = query
            pageToDownload = 1
            totalPages = nil
            queryPhotos = []
        }
        
        Task {
            do {
                let searchResult = try await imageService.searchPhotosMatching(lastQuery, page: pageToDownload)
                if searchResult.results.isEmpty { throw AppError.emptyResultFromApi }
                
                let isMorePhotosAvailable = pageToDownload < searchResult.totalPages
                
                await MainActor.run {
                    if isMorePhotosAvailable { pageToDownload += 1 }
                    totalPages = searchResult.totalPages
                    queryPhotos.append(contentsOf: searchResult.results)
                }
                
                await presentrer.process(queryPhotos, isMorePhotosAvailable: isMorePhotosAvailable)
            } catch {
                await presentrer.process(error)
            }
        }
    }
}

extension PhotosListInteractor: ImageProviderProtocol {
    func loadImageFor(_ urlString: String) async throws -> Data {
        let imageData = try await imageService.loadImageFor(urlString)
        return imageData
    }
}
