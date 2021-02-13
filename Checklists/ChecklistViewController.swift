//
//  ViewController.swift
//  Checklists
//
//  Created by Subvert on 05.02.2021.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var items = [ChecklistItem]()
    var indexPathToEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        print("Document folder is \(documentHistory())")
        print("Data file path is \(dataFilePath())")
        
    }
    
    //MARK: - Core Data
    
    func documentHistory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentHistory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
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
        
        return cell
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].checkmark.toggle()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.indexPathToEdit = indexPath.row
            self.performSegue(withIdentifier: "EditItem", sender: self)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.saveChecklistItems()
        }
        
        editAction.backgroundColor = UIColor.systemGreen
        deleteAction.backgroundColor = UIColor.systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    //MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }
        
        if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            controller.itemToEdit = items[indexPathToEdit!]
        }
    }
    
}

//MARK: - Protocol Delegate Methods

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        items.append(item)
        
        let indexPath = IndexPath(row: items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        saveChecklistItems()
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = item.text
            }
        }
        
        saveChecklistItems()
        navigationController?.popViewController(animated: true)
    }
}
