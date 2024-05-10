//
//  ViewController.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//

import UIKit

class HomeController: UIViewController {
    
    lazy var titleView: TitleView = {
        let title = TitleView(motherSize: CGSize(width: view.frame.width, height: 65))
//        title.textFieldView.delegate = self
        title.seachButton.addTarget(self, action: #selector(searchTapped), for: .touchDown)
        return title
    }()
    
    /// Activity indicator to show loading state
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.transform = view.transform.scaledBy(x: 10, y: 10)
        view.tintColor = .white
        return view
    }()
    /// Collection view to display GIFs
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.register(MainTableViewCell.self, forCellReuseIdentifier: "tableCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
//        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.showsVerticalScrollIndicator = false
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
        stack.layer.borderWidth = 0.5
        stack.addSubview(indicatorView)
        indicatorView.centerX(inView: stack)
        indicatorView.centerY(inView: stack)
        return stack
    }()
    
    let homeViewModel = HomeViewModel(nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .green
        view.addSubview(stackView)
        stackView.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, paddingTop: 60)
//        setupObservers()
    }
    
    // MARK: - Setup Binders
    
    /// Set up observers for view model properties
//    private func setupObservers() {
//        setupLoadedObserver()
//        setupIsLoadingObserver()
//        setupErrorObserver()
//    }
//    
//    /// Set up observer for data loaded state
//    private func setupLoadedObserver() {
//        homeViewModel.isLoaded.binds({[weak self] success in
//            if let _ = success {
//                DispatchQueue.main.async {
//                    if let items = self?.homeViewModel.reloadIndexes(){
//                        self?.tableView.insertRows(at: items, with: .automatic)
//                    }else{
//                        self?.tableView.reloadData()
//                    }
//                }
//            }
//        })
//    }
//    
//    /// Set up observer for loading state
//    private func setupIsLoadingObserver() {
//        homeViewModel.isLoading.binds({[weak self] isLoading in
//            self?.loadingAnimation(isLoading)
//        })
//    }
//    
//    /// Set up observer for error state
//    private func setupErrorObserver() {
//        homeViewModel.error.binds({[weak self] error in
//            if let _ = error {
//                self?.loadingAnimation(false)
//                self?.homeViewModel.showingErrorToast()
//            }
//        })
//    }
//    
//    // MARK: - Loading View
//    
//    /// Handle loading animation
//    private func loadingAnimation(_ isLoading: Bool) {
//        if isLoading {
//            DispatchQueue.main.async {[weak self] in
//                self?.tableView.layer.opacity = 0
//                self?.indicatorView.startAnimating()
//            }
//        } else {
//            DispatchQueue.main.async {[weak self] in
//                self?.tableView.layer.opacity = 1
//                self?.indicatorView.stopAnimating()
//            }
//        }
//    }
    
    /// Action when search button is tapped
    @objc func searchTapped() {
//        let _ = homeViewModel.SearchAction(customSearchField.textFieldView)
    }


}

extension HomeController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return homeViewModel.getCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return homeViewModel.getTableCellHeight(indexPath)
    }
    
    
    
}
