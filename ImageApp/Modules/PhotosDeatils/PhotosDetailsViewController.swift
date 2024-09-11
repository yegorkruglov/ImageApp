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
    
    // MARK: - ui elements
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "star")
        return view
    }()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.loadImage()
    }
}

extension PhotosDetailsViewController {
    func configureWith(_ photo: Photo) {
        interactor.configureWith(photo)
    }
    
    func display(_ image: UIImage) {
        imageView.image = image
    }
}

private extension PhotosDetailsViewController {
    func setup() {
        addViews()
        setupViews()
        makeConstraints()
    }
    
    func addViews() {
        [imageView].forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupViews() {
        view.backgroundColor = .systemGray6
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ]
        )
        
    }
}
