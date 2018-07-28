//
//  ViewController.swift
//  LocalStorageProject
//
//  Created by TEAM LVS on 7/28/18.
//  Copyright © 2018 Pankaj Kapoor. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["First Item", "Second Item", "Third Item"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "Type a new item name in the field below.", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (innerTextField) in
            innerTextField.placeholder = "Add Item Name"
            textField = innerTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Add Item Pressed \(String(describing: textField.text))")
            
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

