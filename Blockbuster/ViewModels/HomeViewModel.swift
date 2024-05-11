//
//  HomeViewModel.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import Foundation
import UIKit

final class HomeViewModel {
    
    static var shared = NetworkService()
    
    // MARK: - Observable Properties
    
    /// Observable property to track whether data is loaded
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    
    /// Observable property to track loading state
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    
    /// Observable property to track error state
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    
    // MARK: - Methods
    
    /// Checks for internet connectivity before making API calls
    private func checkInternet(completion: @escaping (Bool) -> Void) {
        HomeViewModel.shared.checkConnectivity(completion: { [weak self] havingInternet in
            if havingInternet {
                completion(true)
            } else {
                self?.error.value = true
            }
        })
    }
 
    
    // MARK: - Table View Methods
    
    /// Returns the configured cell for the table view
    func getCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MovieTableViewCell
        if indexPath.row == 0 {
            cell.type = .all
        } else {
            cell.type = .popular
        }
        return cell
    }
    
    /// Returns the height for the table view cell at the specified index path
    func getTableCellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else {
            return 220
        }
    }
    
    /// Returns the number of cells in the table view
    func getCellCount() -> Int {
        return 2
    }
}
