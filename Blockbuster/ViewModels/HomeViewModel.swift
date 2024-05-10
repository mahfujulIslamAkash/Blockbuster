//
//  HomeViewModel.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//


import Foundation
import UIKit

class HomeViewModel {
    
    static var shared = NetworkService()
    // MARK: - Observable Properties
    
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
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
 
    
    // MARK: - Collection View Methods
    
    /// Returns the configured cell for the collection view
    func getCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MainTableViewCell
        if indexPath.row == 0{
            cell.type = .all
        }else{
            cell.type = .popular
        }
        return cell
    }
    func getTableCellHeight(_ indexPath: IndexPath)-> CGFloat{
        if indexPath.row == 0{
            return 250
        }else{
            return 220
        }
    }
    func getCellCount() -> Int{
        return 2
    }
    
}
