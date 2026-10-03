//
//  FilterListViewController.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 29.09.2026.
//

import UIKit

final class FilterListViewController: UIViewController {

    private let filterListCollectionView = FilterListCollectionView()
    private let filterStore: FilterStoreProtocol
    private let searchController = UISearchController(searchResultsController: nil)
    var onFiltersChanged: (() -> Void)?
    
    init(filterStore: FilterStoreProtocol) {
        self.filterStore = filterStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationItem()
        setupSearchController()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSearchResults(for: searchController)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        filterListCollectionView.isEditing = editing
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeView)
        )
        
        navigationItem.title = "Custom filters"
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search filters"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupCollectionView() {
        view.addSubview(filterListCollectionView)
        filterListCollectionView.model = filterStore.filters
        filterListCollectionView.onDelete = { [weak self] filter in
            self?.deleteFilter(filter)
        }
        
        NSLayoutConstraint.activate([
            filterListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            filterListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func closeView() {
        dismiss(animated: true)
    }
    
    private func deleteFilter(_ filter: String) {
        guard let index = filterStore.filters.firstIndex(of: filter) else { return }
        filterStore.remove(at: index)
        updateSearchResults(for: searchController)
        
        if filterStore.isEmpty {
            setEditing(false, animated: true)
        }
        onFiltersChanged?()
    }
}

// MARK: - Extensions

extension FilterListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            filterListCollectionView.model = filterStore.filters
            return
        }
        
        let filteredCustomFilters = filterStore.filters.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
        filterListCollectionView.model = filteredCustomFilters
    }
}
