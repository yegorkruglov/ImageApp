//
//  StorageService.swift
//  ImageApp
//
//  Created by Egor Kruglov on 10.09.2024.
//

import Foundation

protocol StorageServiceProtocol {
    func loadDataFor(_ urlString: String) throws -> Data?
    func save(_ data: Data, for urlString: String) throws
}

final class StorageService: StorageServiceProtocol {
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func loadDataFor(_ urlString: String) throws -> Data? {
        let fileName = try makeFileNameFrom(urlString)
        let fileUrl = fileManager.temporaryDirectory.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileUrl.path) else { return nil }
        
        let data = try Data(contentsOf: fileUrl)
        return data
    }
    
    func save(_ data: Data, for urlString: String) throws  {
        let fileName = try makeFileNameFrom(urlString)
        let fileUrl = fileManager.temporaryDirectory.appendingPathComponent(fileName)
        
        try data.write(to: fileUrl)
    }
    
    private func makeFileNameFrom(_ urlString: String) throws -> String {
        guard
            let components = URLComponents(string: urlString),
            let lastPath = components.url?.lastPathComponent
        else { throw NetworkError.invalidUrl }
        
        let queryValues = components.queryItems?.compactMap { $0.value }.joined() ?? ""
        let combined = lastPath + queryValues
        let cleanedString = combined.replacingOccurrences(of: "[a-zA-Z-.]", with: "", options: .regularExpression)
        
        return cleanedString
    }
}
