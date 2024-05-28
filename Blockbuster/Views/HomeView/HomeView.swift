//
//  HomeView.swift
//  Blockbuster
//
//  Created by Mahfujul islam Akash on 5/27/24.
//

import UIKit

class HomeView: UIView {
    
    lazy var titleView: TopView = {
        let title = TopView(motherSize: CGSize(width: frame.width, height: 65))
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
    
    init(_ frame: CGRect = .zero){
        super.init(frame: frame)
        updateUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    func updateUI(){
        backgroundColor = UIColor(hexString: "3B2050")
        
        // Add stack view to view hierarchy
        addSubview(stackView)
        stackView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 60)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    
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
