//
//  SearchQueriesService.swift
//  ImageApp
//
//  Created by Egor Kruglov on 08.09.2024.
//

import Foundation

protocol SearchQueriesServiceProtocol {
    func getSavedQueries() -> [String]
    func saveQuery(_ text: String)
}

final class SearchQueriesService: SearchQueriesServiceProtocol {
    
    private let searchKey: String
    private let maxQueries: Int
    private let userDefaults: UserDefaults
    
    init(searchKey: String, maxQueries: Int, userDefaults: UserDefaults) {
        self.searchKey = searchKey
        self.maxQueries = maxQueries
        self.userDefaults = userDefaults
    }
    
    func getSavedQueries() -> [String] {
        guard let queries = userDefaults.array(forKey: searchKey) as? [String] else { return [] }
        return queries
    }
    
    func saveQuery(_ text: String) {
        var savedQueries = getSavedQueries()
        
        if let index = savedQueries.firstIndex(of: text) {
            savedQueries.remove(at: index)
        }
        
        savedQueries.insert(text, at: 0)
        
        if savedQueries.count > maxQueries {
            savedQueries = Array(savedQueries.prefix(maxQueries))
        }
        
        userDefaults.set(savedQueries, forKey: searchKey)
    }
}
