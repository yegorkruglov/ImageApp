//
//  DependenciesBuilder.swift
//  ImageApp
//
//  Created by Egor Kruglov on 11.09.2024.
//

import Foundation

enum DependenciesBuilder {
    static func build() -> Dependecies {
        let decoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        let networker = Networker(session: URLSession.shared, decoder: decoder)
        let api = UnsplashApi(
            networker: networker,
            baseUrl: "https://api.unsplash.com/",
            token: "zyXBhcA4JPT4gNCyFIMH3ioM-q0wUijpAowZHsrQ7HA"
        )
        let fileManager = FileManager.default
        let storageManger = StorageService(fileManager: fileManager)
        let imageService = ImageService(api: api, storageService: storageManger)
        let searchQueriesService = SearchQueriesService(
            searchKey: "searchQueries",
            maxQueries: 5,
            userDefaults: UserDefaults.standard
        )
        
        return Dependecies(
            decoder: decoder,
            networker: networker,
            api: api,
            fileManager: fileManager,
            storageManger: storageManger,
            imageService: imageService,
            searchQueriesService: searchQueriesService
        )
    }
}
