//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Juliano Santos on 7/1/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorys()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let ac = UIAlertController(title: "Add New Todoy Category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            if let safeText = textField.text {
                let category = Category(context: self.context)
                if !safeText.isEmpty {
                    category.name = safeText
                    self.categoryArray.append(category)
                    self.saveCategory()
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
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error on saving category context")
        }
        
        tableView.reloadData()
    }
    
    func loadCategorys(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            try categoryArray = context.fetch(request)
        } catch {
            print("Error fetching data from category context")
        }
        
        tableView.reloadData()
    }
}
