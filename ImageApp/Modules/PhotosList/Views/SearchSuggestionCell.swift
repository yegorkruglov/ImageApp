//
//  SearchSuggestionCell.swift
//  ImageApp
//
//  Created by Egor Kruglov on 08.09.2024.
//

import UIKit

final class SearchSuggestionCell: UITableViewCell {
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(text: String) {
        titleLabel.text = text
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        
        [backView, titleLabel].forEach { subview in
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(
            [
                backView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                backView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                backView.leftAnchor.constraint(equalTo: self.leftAnchor),
                backView.rightAnchor.constraint(equalTo: self.rightAnchor),
                titleLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),
                titleLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -16),
                titleLabel.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 16),
                titleLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -16)
            ]
        )
    }
}
