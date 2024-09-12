//
//  AppError.swift
//  ImageApp
//
//  Created by Egor Kruglov on 11.09.2024.
//

import Foundation

enum AppError: Error {
    case networkError(NetworkError)
    case emptyResultFromApi
    case invalidQuery
    case noAccessToPhotoLibrary
}
