//
//  PhotoCell.swift
//  ImageApp
//
//  Created by Egor Kruglov on 07.09.2024.
//

import UIKit

protocol ImageProviderProtocol: AnyObject {
    func loadImageFor(_ urlString: String) async throws -> Data
}

final class PhotoCell: UICollectionViewCell {
    weak var imageProvider: ImageProviderProtocol?
    
    private var urlString: String?
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isHidden = true
        return view
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, authorLabel])
        stack.backgroundColor = .systemBackground
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageProvider = nil
        urlString = nil
        imageView.image = nil
        activityIndicator.startAnimating()
        nameLabel.text = nil
        authorLabel.text = nil
    }
    
    func configureWith(_ photo: Photo) {
        nameLabel.text = photo.description
        authorLabel.text = "by \(photo.user.username)"
        guard let urlString = photo.urls.thumb else { return }
        self.urlString = urlString
        setImage(urlString)
    }
    private func setupUI() {
        [imageView, activityIndicator, stackView].forEach { subview in
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            
        }
        
        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: self.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
                
                activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ]
        )
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    private func setImage(_ urlString: String) {
        Task {
            guard let imageData = try await imageProvider?.loadImageFor(urlString) else { return }
            await MainActor.run {
                if urlString == self.urlString {
                    activityIndicator.stopAnimating()
                    imageView.image = UIImage(data: imageData)
                    imageView.isHidden = false
                }
            }
        }
    }
}
