//
//  ViewController.swift
//  LocalStorageProject
//
//  Created by TEAM LVS on 7/28/18.
//  Copyright © 2018 Pankaj Kapoor. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var selectedCategory : Category? {
        didSet{
            print(selectedCategory?.categoryName ?? "Empty Value")
            loadItems()
        }
    }
//    var itemArray = [ItemDetail]()
    var itemArray = [ItemDetailCoreData]()
//    var dataFilePath : Any?
//    let userDefaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(MyConstants.ITEMS_PLIST)
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //To Print Path of SQLITE data model
        print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        if let items = userDefaults.array(forKey: MyConstants.ITEMS_LIST_ARRAY_KEY) as? [ItemDetail]{
//            itemArray = items
//        }
        
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
        saveItem()
        
        //To Delete Item
//        deleteItem(position: indexPath.row)
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "Type a new item name in the field below.", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (innerTextField) in
            innerTextField.placeholder = "Add Item Name"
            textField = innerTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let itemDetail = ItemDetailCoreData(context: self.context)
            itemDetail.itemName = textField.text!
            itemDetail.checked = false
            itemDetail.parentCategory = self.selectedCategory
            self.itemArray.append(itemDetail)
            self.tableView.reloadData()            
//            self.userDefaults.set(self.itemArray, forKey: MyConstants.ITEMS_LIST_ARRAY_KEY)
           
            self.updatePlist()
            self.saveItem()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItem(){
        do{
            try context.save()
        }catch{
            print("Save Item ERROR \(error)")
        }
    }
    func updatePlist() {
//        let encoder = PropertyListEncoder()
//        do{
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath)
//        }catch{
//            print("Encoding Error \(error)")
//        }
    }
    
    func loadItems(with request : NSFetchRequest<ItemDetailCoreData> = ItemDetailCoreData.fetchRequest(), predicate : NSPredicate? = nil){
//        if let data = try? Data(contentsOf: dataFilePath){
//            let decoder = PropertyListDecoder()
//            do{
////                decoder.decode([ItemDetail].self, from: data)
//                itemArray = try decoder.decode([ItemDetail].self, from: data)
//            }catch{
//                print("Load Item Error \(error)")
//            }
//
//        }
        
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", (selectedCategory?.categoryName!)!)

        if let additionalPredicate = predicate {

            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])

            request.predicate = compoundPredicate

        }else{
            request.predicate = categoryPredicate
        }

        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Fetch Request Exception \(error)")
        }
        
        tableView.reloadData()
    }
    
    func deleteItem(position : Int) {
        context.delete(itemArray[position])
        itemArray.remove(at: position)
        saveItem()
        tableView.reloadData()
    }
}

extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        let request : NSFetchRequest<ItemDetailCoreData> = ItemDetailCoreData.fetchRequest()

        let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)

//        request.predicate = predicate

        let sortDescriptor = NSSortDescriptor(key: "itemName", ascending: true)

        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
                
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            //To RUn the code in main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
