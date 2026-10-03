//
//  FilterStorage.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 02.10.2026.
//

import Foundation

protocol FilterStorageProtocol {
    func loadFilters() -> [String]
    func saveFilters(_ filters: [String])
}

struct FilterStorage: FilterStorageProtocol {
    private let filtersKey = "cachedFilters"
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func loadFilters() -> [String] {
        defaults.stringArray(forKey: self.filtersKey) ?? []
    }
    
    func saveFilters(_ filters: [String]) {
        defaults.set(filters, forKey: self.filtersKey)
    }
}
