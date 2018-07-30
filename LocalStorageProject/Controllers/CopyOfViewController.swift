//
//  ViewController.swift
//  LocalStorageProject
//
//  Created by TEAM LVS on 7/28/18.
//  Copyright © 2018 Pankaj Kapoor. All rights reserved.
//

import UIKit

class CopyOfViewController : UITableViewController {
    
    var itemArray : [ItemDetail] = [ItemDetail]()
    //    var dataFilePath : Any?
    //    let userDefaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(MyConstants.ITEMS_PLIST)
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if let items = userDefaults.array(forKey: MyConstants.ITEMS_LIST_ARRAY_KEY) as? [ItemDetail]{
        //            itemArray = items
        //        }
        loadItems()
        
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
        updatePlist()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "Type a new item name in the field below.", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (innerTextField) in
            innerTextField.placeholder = "Add Item Name"
            textField = innerTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let itemDetail = ItemDetail(itemName: textField.text!, checked: false)
            self.itemArray.append(itemDetail)
            self.tableView.reloadData()
            //            self.userDefaults.set(self.itemArray, forKey: MyConstants.ITEMS_LIST_ARRAY_KEY)
            
            self.updatePlist()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItem(){
        
    }
    func updatePlist() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath)
        }catch{
            print("Encoding Error \(error)")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath){
            let decoder = PropertyListDecoder()
            do{
                //                decoder.decode([ItemDetail].self, from: data)
                itemArray = try decoder.decode([ItemDetail].self, from: data)
            }catch{
                print("Load Item Error \(error)")
            }
            
        }
        
    }
    
}

