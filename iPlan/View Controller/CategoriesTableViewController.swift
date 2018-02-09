//
//  ViewController.swift
//  iPlan
//
//  Created by Simone Grant on 2/9/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoriesTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var sections: Results<Section>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadEntries()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = sections?[indexPath.row] {
            cell.textLabel?.text = category.categoryName
            guard let color = UIColor(hexString: category.color) else { fatalError() }
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }

    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "goToEntries", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.entrySelected = sections?[indexPath.row]
        }
    }
    
    // MARK: - Manipulate Realm data
    
    //load
    func loadEntries() {
        sections = realm.objects(Section.self)
        tableView.reloadData()
    }
    
    //save
    func saveSection(section: Section) {
        do {
            try realm.write {
                realm.add(section)
            }
        } catch {
            print("Could not save entry", error)
        }
        tableView.reloadData()
    }
    
    //delete and update data
    override func updateModel(at indexPath: IndexPath) {
        if let deleteItem = sections?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(deleteItem)
                }
            } catch {
                print("Could not delete section", error)
            }
        }
    }
    
    // MARK: - Add Sections
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new section", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let newSection = Section()
            newSection.categoryName = textField.text!
            newSection.color = UIColor.randomFlat.hexValue()
            self.saveSection(section: newSection)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (textfield) in
            textField = textfield
            textField.placeholder = "Add a new section"
        }
        present(alert, animated: true, completion: nil)
    }
    

}

