//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Comprar ações", "Ir na farmácia", "Arrumar choveiro", "Pagar contas", "Ir na farmácia", "Arrumar choveiro", "Pagar contas", "Ir na farmácia", "Arrumar choveiro", "Pagar contas", "Ir na farmácia", "Arrumar choveiro", "Pagar contas", "Ir na farmácia", "Arrumar choveiro", "Pagar contas", "Ir na farmácia", "Arrumar choveiro", "Pagar contas", "Ir na farmácia", "Arrumar choveiro", "Pagar contas", "Ir na farmácia", "Arrumar choveiro", "Pagar contas"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    
}

