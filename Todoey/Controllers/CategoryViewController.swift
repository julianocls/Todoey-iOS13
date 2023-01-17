//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Juliano Santos on 7/1/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categoriesArray: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Categories added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let ac = UIAlertController(title: "Add New Todoy Category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            if let safeText = textField.text {
                let category = Category()
                if !safeText.isEmpty {
                    category.name = safeText
                    self.save(category: category)
                }
            }

        }
        
        ac.addTextField {
            (text) in
            text.placeholder = "Add new category"
            textField = text
        }
        
        ac.addAction(action)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    //MARK: - Model Manipulation Method
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
//                print(Realm.Configuration.defaultConfiguration.fileURL!)
            }
        } catch {
            print("Error saving category context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categoriesArray = realm.objects(Category.self)
        
//        do {
//            try categoriesArray = context.fetch(request)
//        } catch {
//            print("Error fetching data from category context \(error)")
//        }
//
        tableView.reloadData()
    }
}
