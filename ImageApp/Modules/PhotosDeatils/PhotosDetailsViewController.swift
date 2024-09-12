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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
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
        imageView.frame = scrollView.bounds
    }
}

extension PhotosDetailsViewController {
    func configureWith(_ photo: Photo) {
        interactor.configureWith(photo)
        title = photo.description
    }
    
    func display(_ image: UIImage) {
        imageView.image = image
    }
}

extension PhotosDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

private extension PhotosDetailsViewController {
    func setup() {
        addViews()
        setupViews()
        makeConstraints()
    }
    
    func addViews() {
        scrollView.addSubview(imageView)
        [scrollView].forEach { subview in
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
                scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
               
            ]
        )
    }
}
