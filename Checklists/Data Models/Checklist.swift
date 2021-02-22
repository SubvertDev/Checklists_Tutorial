//
//  Checklist.swift
//  Checklists
//
//  Created by Subvert on 17.02.2021.
//

import UIKit

class Checklist: NSObject, Codable {
    
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checkmark {
            count += 1
        }
        return count
    }
}
