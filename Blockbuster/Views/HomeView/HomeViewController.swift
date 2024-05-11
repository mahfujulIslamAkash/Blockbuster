//
//  HomeViewController.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var titleView: TopView = {
        let title = TopView(motherSize: CGSize(width: view.frame.width, height: 65))
        title.searchButton.addTarget(self, action: #selector(searchTapped), for: .touchDown)
        return title
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let controller = UIRefreshControl()
        controller.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return controller
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: "tableCell")
        view.delegate = self
        view.dataSource = self
        view.refreshControl = refreshControl
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor(hexString: "262736")
        view.separatorStyle = .none
        return view
    }()
    
    /// Stack view to organize UI components
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 15
        stack.addArrangedSubview(titleView)
        stack.addArrangedSubview(tableView)
        return stack
    }()
    
    let homeViewModel = HomeViewModel()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set background color
        view.backgroundColor = UIColor(hexString: "3B2050")
        
        // Add stack view to view hierarchy
        view.addSubview(stackView)
        stackView.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, paddingTop: 60)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        NetworkService.shared.checkConnectivity(completion: {[weak self] success in
            if !success{
                self?.showAlert()
            }
        })
    }
    
    // MARK: - Actions
    
    /// Action when search button is tapped
    @objc func searchTapped() {
        // Not implemented yet
        // Implement search functionality here
    }
    
    /// Action when pull-to-refresh is triggered
    @objc func refreshData(_ sender: Any) {
        // Reload table view data and end refreshing
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.getCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return homeViewModel.getCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return homeViewModel.getTableCellHeight(indexPath)
    }
}
