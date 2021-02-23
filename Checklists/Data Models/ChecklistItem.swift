//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Subvert on 07.02.2021.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checkmark = false
    
    init(text: String, checkmark: Bool = false) {
        self.text = text
        self.checkmark = checkmark
        super.init()
    }
}
