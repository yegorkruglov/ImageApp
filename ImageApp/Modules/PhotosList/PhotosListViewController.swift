//
//  PhotosListViewController.swift
//  ImageApp
//
//  Created by Egor Kruglov on 07.09.2024.
//

import UIKit

final class PhotosListViewController: UIViewController {
    
    // MARK: - dependencies
    
    private weak var coordinator: AppCoordinator?
    private let interactor: PhotosListInteractorProtocol

    // MARK: - ui elements
    
    private var isGridLayout: Bool = false
    
    private(set) lazy var searchController: UISearchController = {
        let sc = UISearchController()
        return sc
    }()

    private(set) lazy var photosCollectionView: UICollectionView = {
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
    
    private(set) lazy var searchSuggestionsTableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.register(SearchSuggestionCell.self, forCellReuseIdentifier: SearchSuggestionCell.identifier)
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .none
        tv.alpha = 0
        tv.estimatedRowHeight = 1
        tv.backgroundColor = .systemGray6
        return tv
    }()
    
    // MARK: - initilizer
    
    init(interactor: PhotosListInteractorProtocol) {
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
        interactor.viewDidLoad()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}

private extension PhotosListViewController {
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
        [photosCollectionView, searchSuggestionsTableView].forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupViews() {
        view.backgroundColor = .systemGray6
        title = "Feed"
        setupGridSwitch()
        setupSearchController()
    }
    
    func makeConstraints() {
        [photosCollectionView, searchSuggestionsTableView].forEach { subview in
            NSLayoutConstraint.activate(
                [
                    subview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
                    subview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
                    subview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                    subview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
                ]
            )
        }
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
                photosCollectionView.setCollectionViewLayout(makeCollectionViewLayout(), animated: true)
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
