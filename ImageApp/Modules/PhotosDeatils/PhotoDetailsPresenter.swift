//
//  PhotoDetailsPresenter.swift
//  ImageApp
//
//  Created by Egor Kruglov on 11.09.2024.
//

import UIKit

protocol PhotoDetailsPresenterProtocol {
    func process(_ error: Error) async 
    func process(_ imageData: Data) async 
    func process(_ photo: Photo)
}

final class PhotoDetailsPresenter: PhotoDetailsPresenterProtocol {
    weak var viewController: PhotosDetailsViewController?
    private var info: String?
    
    func process(_ error: Error) async  {
        
    }
    
    func process(_ imageData: Data) async  {
        guard let image = UIImage(data: imageData) else { return }
        await viewController?.display(image)
    }
    
    func process(_ photo: Photo) {
        if let info {
            viewController?.display(info)
            return
        }
        
        let date = formatDate(from: photo.createdAt)
        let info = [
            photo.description,
            "by: \(photo.user.username)",
            "posted: \(date)"
        ].compactMap { $0 }.joined(separator: "\n")
        
        viewController?.display(info)
    }
    
    private func formatDate(from text: String) -> String {
        let isoFormatter = DateFormatter()
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = isoFormatter.date(from: text) else { return text }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")
        
        let formattedDate = outputFormatter.string(from: date)
        
        return formattedDate
    }
}
