//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Ali on 10/24/17.
//  Copyright © 2017 AlixaBahena. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(_ sender: UIButton){
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()

        // Figure out where that item is in the array

        if newItem.valueInDollars > 50
        {
            if let index = itemStore.allItems.index(of: newItem)
            {
                let indexPath = IndexPath(row: index, section: 0)
                // Insert this new row into the table
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            }
        else
        {
            if let index = itemStore.allItems.index(of: newItem)
            {
                let indexPath = IndexPath(row: index, section: 1)
                // Insert this new row into the table
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }

        
    
    @IBAction func toggleEditingMode(_ sender: UIButton){
        if isEditing {
            // Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            
            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "More than $50"
        default:
            return "Less than $50"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return itemStore.highValueItems.count
       default:
            return itemStore.otherItems.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == itemStore.otherItems.count {
            return 44
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        //let item = itemStore.allItems[indexPath.row]

       // cell.textLabel?.text = item.name
        //cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        //return cell
        
        let items: [Item]
        switch indexPath.section {
        case 0:
            items = itemStore.highValueItems
        default:
            items = itemStore.otherItems
        }
        
        if indexPath.section == 1 && indexPath.row == items.count {
            cell.textLabel?.text = "No more items!"
            cell.detailTextLabel?.text = ""
        } else {
            let item = items[indexPath.row]
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "\(item.valueInDollars)"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            //Step-a. Create an alert
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            //Step-b. Add actions
            //a. cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil); ac.addAction(cancelAction)
            
            //b. delete button
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
                (action) -> Void in
                // Remove the item from the store
                self.itemStore.removeItem(item)
                // Also remove that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            })
            ac.addAction(deleteAction)
            
            //c. Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }

}
