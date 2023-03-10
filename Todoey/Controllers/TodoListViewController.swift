//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    let NO_ITEMS_ADDED = "No items added yet"
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedCategory!.name

        tableView.rowHeight = 80.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let navBar = navigationController?.navigationBar, let colour = selectedCategory?.colour {
            searchBar.barTintColor = UIColor(hexString: colour)
            if let uiColor = UIColor(hexString: colour) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithTransparentBackground()
                navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(uiColor, returnFlat: true)]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(uiColor, returnFlat: true)]
                navBarAppearance.backgroundColor = uiColor
                navBar.standardAppearance = navBarAppearance
                navBar.scrollEdgeAppearance = navBarAppearance
                navBar.tintColor = ContrastColorOf(uiColor, returnFlat: true)
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = NO_ITEMS_ADDED
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            if item.title != NO_ITEMS_ADDED {
                tableView.deselectRow(at: indexPath, animated: true)
                
                do {
                    try realm.write {
                        item.done = !item.done
                    }
                } catch {
                    print("Error on saving context")
                }
                
                self.tableView.reloadData()
            }
        }
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
                            item.dateCreated = Date()
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
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        if let items = todoItems {
            for _ in items {
                for item in items {
                    if item.done {
                        do {
                            try realm.write {
                                realm.delete(item)
                            }
                            break
                        } catch {
                            print("Error deleting item")
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
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
    
    //MARK: - Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
