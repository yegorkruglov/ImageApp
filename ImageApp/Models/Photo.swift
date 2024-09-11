//
//  Photo.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
    let total, totalPages: Int
    let results: [Photo]
}

// MARK: - Photo
struct Photo: Codable, Hashable {
    let id: String
    let description: String?
    let urls: Urls
    let user: User
}

// MARK: - Urls
struct Urls: Codable, Hashable {
    let raw, full, regular, small: String?
    let thumb, smallS3: String?
}

// MARK: - User
struct User: Codable, Hashable {
    let username: String
}
