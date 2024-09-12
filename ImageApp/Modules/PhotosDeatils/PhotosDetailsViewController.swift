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
        scrollView.isHidden = true
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        view.startAnimating()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
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
    }
    
    func display(_ image: UIImage) {
        imageView.image = image
        activityIndicator.stopAnimating()
        scrollView.isHidden = false
        setupNavBarButtons()
    }
    
    func display(_ info: String) {
        showInfoAlert(photoInfo: info)
    }
    
    func receiveImageToShare(_ image: UIImage) {
        shareImage(image, from: self)
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
        [scrollView, activityIndicator].forEach { subview in
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
                scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                
                activityIndicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
            ]
        )
    }
    
    func setupNavBarButtons() {
        let InfoButton = makeBarButton(image: "info.circle", action: interactor.requestedInfo)
        let DownloadButton = makeBarButton(image: "arrow.down.circle", action: nil)
        let ShareButton = makeBarButton(image: "square.and.arrow.up.circle", action: interactor.requesteImageToShare)
        
        navigationItem.setRightBarButtonItems([InfoButton, DownloadButton, ShareButton], animated: true)
    }
    
    func makeBarButton(image: String, action: (() -> Void)?) -> UIBarButtonItem{
        let action = UIAction { _ in
            action?()
        }
        
        let button = UIBarButtonItem(
            image: UIImage(systemName: image),
            primaryAction: action
        )
        
        return button
    }
    
    func showInfoAlert(photoInfo: String) {
        let alertController = UIAlertController(
            title: "Info",
            message: photoInfo,
            preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction.init(title: "Close", style: .default))
        
        present(alertController, animated: true)
    }
    
    func shareImage(_ image: UIImage, from viewController: UIViewController) {
        let imageToShare = [image]
        
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
