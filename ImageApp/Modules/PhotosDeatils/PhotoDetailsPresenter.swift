//
//  PhotoDetailsPresenter.swift
//  ImageApp
//
//  Created by Egor Kruglov on 11.09.2024.
//

import UIKit
import Photos

protocol PhotoDetailsPresenterProtocol {
    func process(_ error: Error) async 
    func process(_ imageData: Data) async 
    func process(_ photo: Photo)
    func requesteImageToShare()
    func requestedToSaveImage()
}

final class PhotoDetailsPresenter: PhotoDetailsPresenterProtocol {
    weak var viewController: PhotosDetailsViewController?
    private var image: UIImage?
    private var info: String?
    
    func process(_ error: Error) async  {
        
    }
    
    func process(_ imageData: Data) async  {
        if let image {
            await viewController?.display(image)
            return
        }
        
        guard let image = UIImage(data: imageData) else { return }
        self.image = image
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
    
    func requesteImageToShare() {
        guard let image else { return }
        viewController?.receiveImageToShare(image)
    }
    
    func requestedToSaveImage() {
        guard let image else { return }
        saveImageToPhotoLibrary(image: image)
    }

    private func saveImageToPhotoLibrary(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { [weak self] success, error in
                    if success {
//                        self?.viewController?.notify(_ )
                    } else if let error = error {
                        self?.viewController?.display(error)
                    }
                }
            } else {
                let error = AppError.noAccessToPhotoLibrary
                self?.viewController?.display(error)
            }
        }
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
