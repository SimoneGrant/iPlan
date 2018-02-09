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
    var sections: Result<Section>?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = sections?[indexPath.row] {
            cell.textLabel.text = category.name
            guard let color = UIColor(hexString: category.color) else { return }
            cell.backgroundColor = color
            cell.textLabel.color = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }

    //MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToEntries", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.entrySelected = sections?[indexPath.row]
        }
    }
    
    //MARK: - Manipulate Realm data
    
    func loadEntries() {
        entries.realmObjects(Entry.self)
        tableView.reloadData()
    }

}

