//
//  CategoriesTableViewController.swift
//  LocalStorageProject
//
//  Created by TEAM LVS on 7/30/18.
//  Copyright © 2018 Pankaj Kapoor. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoriesTableViewController: UITableViewController {

    var categoryList : Results<CategoryData>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : CategoryData?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
//        let hour = components.hour
//        let minutes = components.minute
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryList?[indexPath.row]
        
        cell.textLabel?.text = category?.categoryName ?? "NO Category Added Yet"
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCategory = categoryList?[indexPath.row]
        performSegue(withIdentifier: "goToCategoryItems", sender: self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Category", message: "Enter a new Category Name", preferredStyle: .alert)
        var textField : UITextField?
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Category Name"
            textField = categoryTextField
        }
        
        let addAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            self.addNewItem(categoryName: textField?.text!)
        }
        
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addNewItem(categoryName : String?) {
        if categoryName?.count != 0 {
            let newCategory = CategoryData()
            newCategory.categoryName = categoryName!
            saveState(categoryData: newCategory)
        }
    }
    
    func saveState(categoryData : CategoryData) {
        do{
            try realm.write {
                realm.add(categoryData)
            }
        }catch{
            print("Save State Error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        categoryList = realm.objects(CategoryData.self)
        tableView.reloadData()
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do{
//            categoryList =  try context.fetch(request)
//        }catch{
//            print("Load Items ERROR \(error)")
//        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategoryItems" {
            let destinationVC = segue.destination as! TodoListViewController
            destinationVC.selectedCategory = selectedCategory
//            if let indexPath = tableView.indexPathForSelectedRow{
//                destinationVC.selectedCategory = categoryList[indexPath.row]
//                print("ON PREPARE")
//            }else{
//                print("ELSE")
//            }
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "geToSecondSegue"{
//            let destinationVC = segue.destination as! SecondViewController
//            destinationVC.textPassedOver = textField.text
//        }
//    }
}
