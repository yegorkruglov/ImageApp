//
//  PhotosListViewController.swift
//  ImageApp
//
//  Created by Egor Kruglov on 07.09.2024.
//

import UIKit

final class PhotosListViewController: UIViewController {
    
    // MARK: - dependencies
    
    let interactor: PhotosListInteractorProtocol
    private weak var coordinator: AppCoordinator?
    
    // MARK: - ui elements
    
    var isFetchingMoreData: Bool = true
    var isMorePhotosAvailable: Bool = true
    private var isGridLayout: Bool = true
    
    private(set) lazy var searchController: UISearchController = {
        let sc = UISearchController()
        return sc
    }()
    
    private var collectionViewCellRegistration: UICollectionView.CellRegistration<PhotoCell, Photo> = {
        UICollectionView.CellRegistration { cell, _, photo in
            cell.configureWith(photo)
        }
    }()
    private var collectionSupplementaryRegistration: UICollectionView.SupplementaryRegistration<LoadingFooterView> = {
        UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionFooter) { supplementaryView, elementKind, indexPath in
            supplementaryView.startLoading()
        }
    }()
    
    private lazy var photosDataSource: UICollectionViewDiffableDataSource<Sections, Photo> = {
        UICollectionViewDiffableDataSource(collectionView: photosCollectionView) {
            [unowned self] collectionView, indexPath, organization in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: collectionViewCellRegistration,
                for: indexPath,
                item: organization
            )
            cell.imageProvider = interactor
            return cell
        }
    }()
    
    private(set) lazy var photosCollectionView: UICollectionView = {
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()
        )
        cv.delegate = self
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 16
        return cv
    }()
    
    private(set) lazy var searchQueriesDataSource: UITableViewDiffableDataSource<Sections, String> = {
        UITableViewDiffableDataSource(tableView: searchSuggestionsTableView) {
            [unowned self] tableView, indexPath, query in
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchSuggestionCell.identifier,
                    for: indexPath
                ) as? SearchSuggestionCell
            else { return UITableViewCell() }
            cell.configureWith(text: query)
            return cell
        }
        
    }()
    
    private(set) lazy var searchSuggestionsTableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.register(SearchSuggestionCell.self, forCellReuseIdentifier: SearchSuggestionCell.identifier)
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
        interactor.loadMoreRandomPhotos()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}

extension PhotosListViewController {
    func display(_ snapshot: PhotosSnapshot, isMorePhotosAvailable: Bool) {
        photosDataSource.apply(snapshot, animatingDifferences: true)
        
        self.isMorePhotosAvailable = isMorePhotosAvailable
        self.isFetchingMoreData = false
        
        if !isMorePhotosAvailable { updateLayout() }
    }
    
    func display(_ snapshot: QueriesSnapshot) {
        searchQueriesDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func toggleViews(showPhotos: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.photosCollectionView.alpha = showPhotos ? 1 : 0
            self.searchSuggestionsTableView.alpha = showPhotos ? 0 : 1
        }
    }
    
    func drainPhotosDataSource() {
        var snapshot = photosDataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        photosDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateLayout() {
        photosCollectionView.setCollectionViewLayout(makeCollectionViewLayout(), animated: true)
    }
}

private extension PhotosListViewController {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemRatio: CGFloat = isGridLayout ? 1/2 : 1
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemRatio),
            heightDimension: .fractionalWidth(itemRatio)
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
        
        if isMorePhotosAvailable {
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            section.boundarySupplementaryItems = [footer]
        }
        
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
        setupPhotosCollectionViewDatasource()
        setupSearcQueriesTableViewDatasource()
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
            UIImage(
                systemName: isGridLayout
                ? "square.stack.fill"
                : "square.grid.2x2.fill"
            )
        }
        
        let gridSwitch: UIBarButtonItem = UIBarButtonItem()
        let gridAction: UIAction = UIAction.init(
            image: imageProvider,
            handler: { [weak self] _ in
                guard let self else { return }
                isGridLayout.toggle()
                updateLayout()
                gridSwitch.image = imageProvider
            }
        )
        gridSwitch.primaryAction = gridAction
        
        navigationItem.rightBarButtonItem = gridSwitch
    }
    
    func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for images"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupPhotosCollectionViewDatasource() {
        var dataSourceSnapshot: NSDiffableDataSourceSnapshot<Sections, Photo> = .init()
        dataSourceSnapshot.appendSections([.main])
        dataSourceSnapshot.appendItems([], toSection: .main)
        
        photosDataSource.apply(dataSourceSnapshot)
        photosDataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueConfiguredReusableSupplementary(
                    using: collectionSupplementaryRegistration, 
                    for: indexPath
                )
                footer.startLoading()
                return footer
            }
            return nil
        }
        photosCollectionView.dataSource = photosDataSource
    }
    
    func setupSearcQueriesTableViewDatasource() {
        var dataSourceSnapshot: NSDiffableDataSourceSnapshot<Sections, String> = .init()
        dataSourceSnapshot.appendSections([.main])
        dataSourceSnapshot.appendItems([], toSection: .main)
        
        searchQueriesDataSource.apply(dataSourceSnapshot)
        searchSuggestionsTableView.dataSource = searchQueriesDataSource
    }
}
