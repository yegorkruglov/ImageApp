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
        view.image = UIImage(systemName: "questionmark")
        return view
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, authorLabel])
        stack.backgroundColor = .systemBackground
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
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
        nameLabel.text = nil
        authorLabel.text = nil
        #warning("update constraints")
    }
    
    func configureWith(_ photo: Photo) {
        nameLabel.text = photo.description
        authorLabel.text = "by \(photo.user?.username ?? "unknown user")"
        guard let urlString = photo.urls?.thumb else { return }
        self.urlString = urlString
        setImage(urlString)
    }
    private func setupUI() {
        [imageView, stackView].forEach { subview in
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            
        }
        let stackViewHeight: CGFloat = self.bounds.height / 3
        
        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: self.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
                stackView.heightAnchor.constraint(equalToConstant: stackViewHeight),
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
                    imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
}
