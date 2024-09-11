//
//  PhotoDetailsBuilder.swift
//  ImageApp
//
//  Created by Egor Kruglov on 11.09.2024.
//

import Foundation

enum PhotoDetailsBuilder {
    static func build() -> PhotosDetailsViewController {
        let presenter = PhotoDetailsPresenter()
        let interactor = PhotoDetailsInteractor(presenter: presenter)
        let vc = PhotosDetailsViewController(interactor: interactor)
        presenter.viewController = vc
        return vc
    }
}
