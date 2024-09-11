//
//  NetworkError.swift
//  ImageApp
//
//  Created by Egor Kruglov on 09.09.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case unknown
    case badResponse
    case decodingError
    case unexpectedStatusCode
}
