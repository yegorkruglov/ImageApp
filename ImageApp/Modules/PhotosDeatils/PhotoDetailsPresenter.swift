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
}

final class PhotoDetailsPresenter: PhotoDetailsPresenterProtocol {
    weak var viewController: PhotosDetailsViewController?
    
    func process(_ error: Error) async  {
        
    }
    
    func process(_ imageData: Data) async  {
        guard let image = UIImage(data: imageData) else { return }
        await viewController?.display(image)
    }
}
