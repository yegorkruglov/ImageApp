//
//  Photo.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

struct Photo: Codable, Hashable {
    let id, slug: String?
    let createdAt, updatedAt, promotedAt: Date?
    let width, height: Int?
    let description: String?
    let urls: Urls?
    let user: User?
    let exif: Exif?
    let location: Location?
}

// MARK: - Exif
struct Exif: Codable, Hashable {
    let make, model, name, exposureTime: String?
    let aperture, focalLength: String?
    let iso: Int?
}

// MARK: - Location
struct Location: Codable, Hashable {
    let name, city, country: String?
    let position: Position?
}

// MARK: - Position
struct Position: Codable, Hashable {
    let latitude, longitude: Double?
}

// MARK: - Urls
struct Urls: Codable, Hashable {
    let raw, full, regular, small: String?
    let thumb, smallS3: String?
}

// MARK: - User
struct User: Codable, Hashable {
    let username, name, firstName: String?
    let lastName, twitterUsername: String?
    let instagramUsername: String?
    let social: Social?
}

// MARK: - Social
struct Social: Codable, Hashable {
    let instagramUsername: String?
    let twitterUsername: String?
}
