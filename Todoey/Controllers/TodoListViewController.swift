//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
                              
       loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.check ? .checkmark : .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        itemArray[indexPath.row].check = !itemArray[indexPath.row].check
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoye Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            if let safeValue = textField.text {
                let item = Item(context: self.context)
                if !safeValue.isEmpty {
                    item.title = safeValue
                    item.check = false
                    self.itemArray.append(item)
                    self.saveItems()
                }
            }
        }
        
        alert.addTextField {
            (alertTexField) in
            alertTexField.placeholder = "Add new item"
            textField = alertTexField
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    //MARK: - Remove selected item    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        
        itemArray.enumerated().forEach { (index, item) in
            if item.check {
                context.delete(item)
                itemArray.remove(at: index)
                saveItems()
            }
        }

    }
    
    //MARK: - Model Manipulation Method
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error on saving context")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context")
        }
    }
    
}
