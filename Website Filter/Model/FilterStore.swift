//
//  FilterStore.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 01.10.2026.
//

import Foundation

protocol FilterStoreProtocol: AnyObject {
    var filters: [String] { get }
    var isEmpty: Bool { get }
    func add(_ rawFilter: String) -> Bool
    func remove(at index: Int)
    func isBlocked(_ url: URL) -> Bool
}

final class FilterStore: FilterStoreProtocol {
    private(set) var filters: [String]
    private let storage: FilterStorageProtocol
    
    private let rule = FilterRule()
    var isEmpty: Bool { filters.isEmpty }
    
    init(cache: FilterStorageProtocol = FilterStorage()) {
        self.storage = cache
        self.filters = cache.loadFilters()
    }
    
    @discardableResult
    func add(_ rawFilter: String) -> Bool {
        let filter = rawFilter.lowercased()
        guard rule.validate(filter).isValid, !filters.contains(filter) else { return false }
        filters.append(filter)
        storage.saveFilters(filters)
        return true
    }
    
    func remove(at index: Int) {
        guard filters.indices.contains(index) else { return }
        filters.remove(at: index)
        storage.saveFilters(filters)
    }
    
    func isBlocked(_ url: URL) -> Bool {
        let target = ((url.host ?? "") + url.path).lowercased()
        return filters.contains { target.contains($0) }
    }
}
