//
//  StorageService.swift
//  ImageApp
//
//  Created by Egor Kruglov on 10.09.2024.
//

import Foundation

protocol StorageServiceProtocol {
    func loadDataFor(_ urlString: String) -> Data?
    func save(_ data: Data, for urlString: String) throws
}

final class StorageService: StorageServiceProtocol {
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func loadDataFor(_ urlString: String) -> Data? {
        return nil
    }

    func save(_ data: Data, for urlString: String) throws  {
        
    }
}
