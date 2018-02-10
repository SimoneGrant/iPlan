//
//  DetailTableViewController.swift
//  iPlan
//
//  Created by Simone Grant on 2/9/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import TableFlip

class DetailTableViewController: SwipeTableViewController {
    
    var entrySelected: Section? {
        didSet {
            loadEntries()
        }
    }
    
    var entries: Results<Entry>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let color = entrySelected?.color else { fatalError() }
        title = entrySelected?.categoryName
        updateNavigation(with: color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateNavigation(with: "ffffff")
    }
    
    // MARK: - Setup
    
    func updateNavigation(with color: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        guard let navColor = UIColor(hexString: color)  else { fatalError("Navigation Bar does not exist.") }
        navBar.barTintColor = navColor
        navBar.tintColor = ContrastColorOf(navColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navColor, returnFlat: true)]
    }
    
    // MARK: - Action
    
    @IBAction func addButtonTriggered(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            if let section = self.entrySelected {
                do {
                    try self.realm.write {
                        let entry = Entry()
                        entry.title = textField.text!
                        entry.date = Date()
                        section.entries.append(entry)
                    }
                } catch {
                    print("Error saving action", error)
                }
            }
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Add task here"
            textField = textfield
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.font = UIFont.init(name: "Avenir", size: 18)
        if let entry = entries?[indexPath.row] {
            cell.textLabel?.text = entry.title
            cell.accessoryType = entry.done ? .checkmark : .none
            //chameleon gradient
            if let color = UIColor(hexString: entrySelected!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(entries!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            } else {
                cell.textLabel?.text = "No Items Added"
            }
        }
            return cell
        }
    
    func animateTable() {
        let top = TableViewAnimation.Table.top(duration: 0.8)
        tableView.animate(animation: top)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let entry = entries?[indexPath.row] {
            print(entry.done)
            do {
                try realm.write {
                    entry.done = !entry.done
                }
            } catch {
                print("Error saving entry", error)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Manipulate Realm data
    
    func loadEntries() {
        entries = entrySelected?.entries.sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let deleteEntry = entries?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(deleteEntry)
                }
            } catch {
                print("Error deleting entry", error)
            }
        }
    }
}


