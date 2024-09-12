//
//  ErrorHandler.swift
//  ImageApp
//
//  Created by Egor Kruglov on 12.09.2024.
//

import Foundation

enum ErrorHandler {
    static func prepareAlertInfoFrom(_ error: Error) -> (String, String) {
        var title = "Unknown error"
        var description =  "We're investigating"
        
        if let appError = error as? AppError {
            switch appError {
            case .emptyResultFromApi:
                title = "Nothing found"
                description = "Try searching smth different"
            case .invalidQuery:
                title = "Invalid query"
                description = "Make sure your quey at least 3 letter (whitespaces do not count)"
            case .noAccessToPhotoLibrary:
                title = "No access to Photo library"
                description = "Check settings, and grant acces"
            case .failedSaving:
                title = "Failed saving image"
                description = "We're already trying to fix"
            }
        }
        
        if let error = error as? NetworkError {
            title = "Network error"
            
            switch error {
            case .invalidUrl:
                description = "Invalid URL"
            case .unknown:
                description = "Something totaly unkown and unexpexted. We're investigating"
            case .badResponse:
                description = "Bad response from server"
            case .decodingError:
                description = "Decoding error. Might be our mistake..."
            case .unexpectedStatusCode:
                description = "Unexpected status code. Didn't see it coming.."
            }
        }
        
        return (title, description)
    }
}
