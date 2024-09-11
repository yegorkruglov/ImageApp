//
//  PhotosDetailsViewController.swift
//  ImageApp
//
//  Created by Egor Kruglov on 07.09.2024.
//

import UIKit

final class PhotosDetailsViewController: UIViewController {
    
    // MARK: - dependecies
    
    weak var coordinator: AppCoordinator?
    private let interactor: PhotoDetailsInteractorProtocol
    
    // MARK: - inits
    
    init(interactor: PhotoDetailsInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
}

extension PhotosDetailsViewController {
    func configureWith(_ photo: Photo) {
        interactor.configureWith(photo)
    }
}

private extension PhotosDetailsViewController {
    func setup() {
        addViews()
        setupViews()
        makeConstraints()
    }
    
    func addViews() {
        
    }
    
    func setupViews() {
        
    }
    
    func makeConstraints() {
        
    }
}
