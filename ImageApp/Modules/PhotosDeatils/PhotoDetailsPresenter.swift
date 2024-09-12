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
        
        let info = """
        
        """
        viewController?.display(info)
    }
}
