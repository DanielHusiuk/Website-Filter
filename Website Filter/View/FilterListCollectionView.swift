//
//  FilterListCollectionView.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 29.09.2026.
//

import UIKit

final class FilterListCollectionView: UICollectionView {
    
    var model: [String] = [] {
        didSet {
            reloadData()
        }
    }
    var onDelete: ((String) -> Void)?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        delegate = self
        dataSource = self
        
        self.register(
            UICollectionViewListCell.self,
            forCellWithReuseIdentifier: "FilterListCell"
        )
        
        backgroundColor = .systemGroupedBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

// MARK: - Extensions

extension FilterListCollectionView: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
}

extension FilterListCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FilterListCell",
                for: indexPath) as? UICollectionViewListCell else {
                return UICollectionViewCell()
            }
            
            let filter = model[indexPath.section]
            var content = UIListContentConfiguration.cell()
            content.text = filter
            
            cell.contentConfiguration = content
            cell.accessories = [
                .delete(displayed: .whenEditing) { [weak self] in
                    self?.onDelete?(filter)
                }
            ]
            return cell
        }
}
