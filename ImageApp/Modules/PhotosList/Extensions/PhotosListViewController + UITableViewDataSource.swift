//
//  PhotosListViewController + UITableViewDataSource.swift
//  ImageApp
//
//  Created by Egor Kruglov on 08.09.2024.
//

import UIKit

extension PhotosListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        searchHistoryElements.count
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchSuggestionCell.identifier,
                for: indexPath
            ) as? SearchSuggestionCell
        else { return UITableViewCell() }
        
//        cell.configureWith(text: searchHistoryElements[indexPath.row])
        return cell
    }
}
