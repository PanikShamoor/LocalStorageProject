//
//  ViewController.swift
//  LocalStorageProject
//
//  Created by TEAM LVS on 7/28/18.
//  Copyright © 2018 Pankaj Kapoor. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray : [ItemDetail] = [ItemDetail]()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = userDefaults.array(forKey: MyConstants.ITEMS_LIST_ARRAY_KEY) as? [ItemDetail]{
//            itemArray = items
//        }else{
//            print("Item Not Available")
//        }
        itemArray.append(ItemDetail(itemName: "First Item" , checked: false))
        itemArray.append(ItemDetail(itemName: "Second Item" , checked: false))
        itemArray.append(ItemDetail(itemName: "Third Item" , checked: false))
//        itemArray.append(ItemDetail(itemName: "Second Item" , checked: false))
//        itemArray.append(ItemDetail(itemName: "Third Item" , checked: false))
//        itemArray.append(ItemDetail(itemName: "Forth Item" , checked: false))
        
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
        let itemDetail = itemArray[indexPath.row]
        cell.textLabel?.text = itemDetail.itemName
        cell.accessoryType = itemDetail.checked ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        tableView.reloadData()
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
            self.itemArray.append(ItemDetail(itemName: textField.text!, checked: false))
            self.tableView.reloadData()            
            self.userDefaults.set(self.itemArray, forKey: MyConstants.ITEMS_LIST_ARRAY_KEY)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

