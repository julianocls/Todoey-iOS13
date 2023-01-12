//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if itemArray?[indexPath.row].title != "No item added yet" {
//
//            tableView.deselectRow(at: indexPath, animated: true)
//
//            itemArray?[indexPath.row].done = !(itemArray?[indexPath.row].done)!
//
//            save(item: (itemArray?[indexPath.row])!)
//
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    }
    
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoye Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            if let safeValue = textField.text, let currentCategory = self.selectedCategory {
                if !safeValue.isEmpty {
                    do {
                        try self.realm.write {
                            let item = Item()
                            item.title = safeValue
                            currentCategory.items.append(item)
                        }

                        self.tableView.reloadData()
                    } catch {
                        print("Error on saving context")
                    }
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
//    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
//
//        for _ in itemArray {
//            for (index, item) in zip(itemArray.indices, itemArray) {
//                if item.check {
//                    context.delete(item)
//                    itemArray.remove(at: index)
//                    saveItems()
//                    break
//                }
//            }
//        }
//
//    }
    
    //MARK: - Model Manipulation Method
    func save(items: List<Item>) {
        do {
            try realm.write {
                realm.add(items)
            }
        } catch {
            print("Error on saving context")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//
//        DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//        }
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//}
