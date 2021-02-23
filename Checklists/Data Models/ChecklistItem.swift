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
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    init(text: String, checkmark: Bool = false) {
        super.init()
        self.text = text
        self.checkmark = checkmark
        itemID = DataModel.nextChecklistItemID()
    }
}
