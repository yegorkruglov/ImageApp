//
//  PhotosListViewController.swift
//  ImageApp
//
//  Created by Egor Kruglov on 07.09.2024.
//

import UIKit

final class PhotosListViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setup() {
        addViews()
        setupViews()
        makeConstraints()
    }
    
    func addViews() {
        
    }
    
    func setupViews() {
        view.backgroundColor = .systemGray6
        title = "Feed"
    }
    
    func makeConstraints() {
        
    }


}

