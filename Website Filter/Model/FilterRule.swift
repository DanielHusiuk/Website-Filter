//
//  FilterRule.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 02.10.2026.
//

import Foundation

struct FilterRuleResult {
    let hasMinLength: Bool
    let notHasSpace: Bool
    var isValid: Bool { hasMinLength && notHasSpace }
}

struct FilterRule {
    func validate(_ text: String) -> FilterRuleResult {
        return FilterRuleResult(
            hasMinLength: text.count >= 2,
            notHasSpace: !text.contains(where: \.isWhitespace)
        )
    }
}
