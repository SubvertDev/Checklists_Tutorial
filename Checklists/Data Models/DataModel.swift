//
//  DataModel.swift
//  Checklists
//
//  Created by Subvert on 20.02.2021.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // MARK: - Data Saving
    
    func documentHistory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentHistory().appendingPathComponent("Checklists.plist")
    }
    
    // --- SAVING ---
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    // --- LOADING ---
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            }
            catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    // --- DEFAULTS ---
    func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1,
                          "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    func sortChecklists() {
        lists.sort { list1, list2 in
            return list1.name.localizedCompare(list2.name) == .orderedAscending
        }
    }
}
