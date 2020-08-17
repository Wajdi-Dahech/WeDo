//
//  CategoryViewController.swift
//  WeDo
//
//  Created by Katsu on 8/6/20.
//  Copyright © 2020 Katsu. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    // MARK:- Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new WeDo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            if let text = textField.text {
                let newCategory = Category()
                newCategory.name = text
                self.save(category: newCategory)
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel!.text = categoryArray?[indexPath.row].name ?? "No Categories Added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: -  Save&Load Categories
    func save(category: Category) {
        
        do {
            
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving context,\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
    //MARK: -  Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category,\(error)")
            }
        }
    }
    
}


