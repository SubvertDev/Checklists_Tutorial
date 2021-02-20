//
//  ViewController.swift
//  Checklists
//
//  Created by Subvert on 05.02.2021.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var indexPathToEdit: Int?
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = checklist.name
        
    }
    
    //MARK: - Core Data
    
    //    func documentHistory() -> URL {
    //        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //        return paths[0]
    //    }
    //
    //    func dataFilePath() -> URL {
    //        return documentHistory().appendingPathComponent("Checklists.plist")
    //    }
    //
    //    // --- SAVING ---
    //    func saveChecklistItems() {
    //        let encoder = PropertyListEncoder()
    //        do {
    //            let data = try encoder.encode(checklist.items)
    //            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
    //        }
    //        catch {
    //            print("Error encoding item array: \(error.localizedDescription)")
    //        }
    //    }
    //
    //    // --- LOADING ---
    //    func loadChecklistItems() {
    //        let path = dataFilePath()
    //        if let data = try? Data(contentsOf: path) {
    //            let decoder = PropertyListDecoder()
    //            do {
    //                checklist.items = try decoder.decode([ChecklistItem].self, from: data)
    //            }
    //            catch {
    //                print("Error decoding item array: \(error.localizedDescription)")
    //            }
    //        }
    //    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as UITableViewCell
        
        let item = checklist.items[indexPath.row]
        
        cell.textLabel?.text = item.text
        cell.accessoryType = item.checkmark ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checklist.items[indexPath.row].checkmark.toggle()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.indexPathToEdit = indexPath.row
            self.performSegue(withIdentifier: "EditItem", sender: self)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.checklist.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
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
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            controller.itemToEdit = checklist.items[indexPathToEdit!]
        }
    }
    
}

//MARK: - Protocol Delegate Methods

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: checklist.items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = item.text
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}
