//
//  PhotosListViewController.swift
//  ImageApp
//
//  Created by Egor Kruglov on 07.09.2024.
//

import UIKit

final class PhotosListViewController: UIViewController {
    
    weak var coordinator: AppCoordinator?
    
    private var isGridLayout: Bool = false
    
    private(set) lazy var searchController: UISearchController = {
        let sc = UISearchController()
        return sc
    }()

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()
        )
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 16
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension PhotosListViewController {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(isGridLayout ? 1 : 1/2),
            heightDimension: .fractionalWidth(isGridLayout ? 1 : 1/2)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setup() {
        addViews()
        setupViews()
        makeConstraints()
    }
    
    func addViews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupViews() {
        view.backgroundColor = .systemGray6
        title = "Feed"
        setupGridSwitch()
        setupSearchController()
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate(
            [
                collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
                collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
                collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }
    
    func setupGridSwitch() {
        var imageProvider: UIImage? {
            isGridLayout ? UIImage(systemName: "square.grid.2x2.fill") : UIImage(systemName: "square.stack.fill")
        }
        
        let gridSwitch: UIBarButtonItem = UIBarButtonItem()
        let gridAction: UIAction = UIAction.init(
            image: imageProvider,
            handler: { [weak self] _ in
                guard let self else { return }
                isGridLayout.toggle()
                collectionView.setCollectionViewLayout(makeCollectionViewLayout(), animated: true)
                gridSwitch.image = imageProvider
            }
        )
        gridSwitch.primaryAction = gridAction
        
        navigationItem.rightBarButtonItem = gridSwitch
    }
    
    func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for images"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
