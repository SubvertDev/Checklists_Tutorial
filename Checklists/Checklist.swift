//
//  Checklist.swift
//  Checklists
//
//  Created by Subvert on 17.02.2021.
//

import UIKit

class Checklist: NSObject {
    
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
