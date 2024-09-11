//
//  Dependencies.swift
//  ImageApp
//
//  Created by Egor Kruglov on 11.09.2024.
//

import Foundation

final class Dependecies {
    let decoder: JSONDecoder
    let networker: NetworkerProtocol
    let api: PhotoApiProtocol
    let fileManager: FileManager
    let storageManger: StorageServiceProtocol
    let imageService: ImageServiceProtocol
    let searchQueriesService: SearchQueriesServiceProtocol
    
    init(
        decoder: JSONDecoder,
        networker: NetworkerProtocol,
        api: PhotoApiProtocol,
        fileManager: FileManager,
        storageManger: StorageServiceProtocol,
        imageService: ImageServiceProtocol,
        searchQueriesService: SearchQueriesServiceProtocol
    ) {
        self.decoder = decoder
        self.networker = networker
        self.api = api
        self.fileManager = fileManager
        self.storageManger = storageManger
        self.imageService = imageService
        self.searchQueriesService = searchQueriesService
    }
}
