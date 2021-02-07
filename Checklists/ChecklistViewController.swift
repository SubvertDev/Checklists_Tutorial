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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let item1 = ChecklistItem()
        item1.text = "Programming"
        items.append(item1)
        
        let item2 = ChecklistItem()
        item2.text = "Read a book"
        items.append(item2)
        
        let item3 = ChecklistItem()
        item3.text = "Go to bed before midnight"
        items.append(item3)
        
        let item4 = ChecklistItem()
        item4.text = "Visit a doctor"
        items.append(item4)
        
        let item5 = ChecklistItem()
        item5.text = "Finish this app"
        items.append(item5)
        
    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as UITableViewCell
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.text
        
        cell.accessoryType = item.checkmark ? .checkmark : .none
        
//        if item.checkmark {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let item = items[indexPath.row]
        
        items[indexPath.row].checkmark.toggle()
        
        tableView.reloadData()
        
//        if let cell = tableView.cellForRow(at: indexPath) {
//            if item.checkmark {
//                cell.accessoryType = .none
//                item.checkmark = false
//            } else {
//                cell.accessoryType = .checkmark
//                item.checkmark = true
//            }
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Actions
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let newRowIndex = items.count
        
        let newItem = ChecklistItem()
        newItem.text = "New row from add button"
        items.append(newItem)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
    
}

