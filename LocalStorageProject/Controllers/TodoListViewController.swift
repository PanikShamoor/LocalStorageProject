//
//  ViewController.swift
//  LocalStorageProject
//
//  Created by TEAM LVS on 7/28/18.
//  Copyright © 2018 Pankaj Kapoor. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    var selectedCategory : CategoryData? {
        didSet{
            loadItems()
        }
    }
    let realm = try! Realm()
//    var itemArray = [ItemDetail]()
    var itemArray : Results<ItemData>?
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
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let itemDetail = itemArray?[indexPath.row]
        cell.textLabel?.text = itemDetail?.itemName ?? "NO Item Added Yet!"
        cell.accessoryType = (itemDetail?.checked)! ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write {
//                    realm.delete(item)
                    item.checked = !item.checked
                }
            }catch{
                print("Error Updating Data")
            }
        }
        
        
        
//        itemArray![indexPath.row].checked = !itemArray[indexPath.row].checked
//        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
//        updatePlist()
//        saveItem()
        
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
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let itemDetail = ItemData()
                        itemDetail.itemName = textField.text!
                        itemDetail.checked = false
                        itemDetail.dateCreated = Date()
                        currentCategory.items.append(itemDetail)
                    }
                }catch{
                    print("Error Saving Data \(error)")
                }
            }
            self.tableView.reloadData()
            
//            itemDetail.parentCategory = self.selectedCategory?.categoryName
//              self.userDefaults.set(self.itemArray, forKey: MyConstants.ITEMS_LIST_ARRAY_KEY)
           
//            self.updatePlist()
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
//    func updatePlist() {
//        let encoder = PropertyListEncoder()
//        do{
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath)
//        }catch{
//            print("Encoding Error \(error)")
//        }
//    }
    
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
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", (selectedCategory?.categoryName)!)
//
//        if let additionalPredicate = predicate {
//
//            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//
//            request.predicate = compoundPredicate
//
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Fetch Request Exception \(error)")
//        }
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
        
        tableView.reloadData()
    }
    
    func deleteItem(position : Int) {
//        context.delete(itemArray[position])
//        itemArray.remove(at: position)
//        saveItem()
//        tableView.reloadData()
    }
}

extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        itemArray = itemArray?.filter("itemName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
        
        
        
        
        
//        let request : NSFetchRequest<ItemDetailCoreData> = ItemDetailCoreData.fetchRequest()
//
//        let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
//
//        let sortDescriptor = NSSortDescriptor(key: "itemName", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//        loadItems(with: request, predicate: predicate)
        
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
