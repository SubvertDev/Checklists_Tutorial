//
//  ViewController.swift
//  Checklists
//
//  Created by Subvert on 05.02.2021.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let item1 = ChecklistItem()
        item1.text = "Programming"
        items.append(item1)
        
        let item2 = ChecklistItem()
        item2.text = "Read a book"
        items.append(item2)
        
        let item3 = ChecklistItem()
        item3.text = "Go to bed before midnight"
        items.append(item3)
        
    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        let label = cell.viewWithTag(1) as! UILabel
        label.text = item.text
        
        if item.checkmark {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if item.checkmark {
                cell.accessoryType = .none
                item.checkmark = false
            } else {
                cell.accessoryType = .checkmark
                item.checkmark = true
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

