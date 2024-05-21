//
//  ShoppingListViewController.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit



final class ShoppingListViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    var listItems: [ListItem] {
        do {
            return try context.fetch(ListItem.fetchRequest())
        } catch {
            print("Couldn't fetch data")
        }
        return [ListItem]()
    }
    private var boughtListItems: [BoughtListItem] {
        do {
            return try context.fetch(BoughtListItem.fetchRequest())
        } catch {
            print("Couldn't fetch data")
        }
        return [BoughtListItem]()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToBuyTitleCell.nibFile, forCellReuseIdentifier: ToBuyTitleCell.identifier)
        tableView.register(ToBuyItemCell.nibFile, forCellReuseIdentifier: ToBuyItemCell.identifier)
        tableView.register(BoughtCellTitle.nibFile, forCellReuseIdentifier: BoughtCellTitle.identifier)
        tableView.register(BoughtItemCell.nibFile, forCellReuseIdentifier: BoughtItemCell.identifier)
        
    }
    
   
    @IBAction func addProductTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: NewProductController.identifier) as? NewProductController else { return }
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}



extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if !listItems.isEmpty {
            numberOfRows += listItems.count + 1
        }
        if !boughtListItems.isEmpty {
            numberOfRows += boughtListItems.count + 1
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !listItems.isEmpty {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ToBuyTitleCell.identifier, for: indexPath) as? ToBuyTitleCell else { return UITableViewCell() }
                return cell
            } else if indexPath.row > 0 && indexPath.row <= listItems.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ToBuyItemCell.identifier, for: indexPath) as? ToBuyItemCell else { return UITableViewCell() }
                cell.lblDesc.text = listItems[indexPath.row - 1].desc
                return cell
            }
        }
        if !boughtListItems.isEmpty {
            if listItems.isEmpty {
                if indexPath.row == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: BoughtCellTitle.identifier, for: indexPath) as? BoughtCellTitle else { return UITableViewCell() }
                    return cell
                }
                if indexPath.row > 0 && indexPath.row <= boughtListItems.count {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: BoughtItemCell.identifier, for: indexPath) as? BoughtItemCell else { return UITableViewCell() }
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: boughtListItems[indexPath.row - 1].desc ?? "")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.boughtLbl.attributedText = attributeString
                    return cell
                }
            } else {
                if indexPath.row == listItems.count + 1 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: BoughtCellTitle.identifier, for: indexPath) as? BoughtCellTitle else { return UITableViewCell() }
                    return cell
                }
                if indexPath.row > (listItems.count + 1) && indexPath.row <= (listItems.count + 1 + boughtListItems.count) {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: BoughtItemCell.identifier, for: indexPath) as? BoughtItemCell else { return UITableViewCell() }
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: boughtListItems[indexPath.row - listItems.count - 2].desc ?? "")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.boughtLbl.attributedText = attributeString
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 && indexPath.row <= listItems.count {
            let listItem = listItems[indexPath.row - 1]
            let boughtItem = BoughtListItem(context: context)
            boughtItem.id = listItem.id
            boughtItem.desc = listItem.desc
            context.delete(listItem)
            (UIApplication.shared.delegate as!
             AppDelegate).saveContext()
            tableView.reloadData()
        } else if !listItems.isEmpty {
            if indexPath.row > (listItems.count + 1) && indexPath.row <= (listItems.count + 1 + boughtListItems.count) {
                let boughtItem = boughtListItems[indexPath.row - listItems.count - 2]
                let listItem = ListItem(context: context)
                listItem.id = boughtItem.id
                listItem.desc = boughtItem.desc
                context.delete(boughtItem)
                (UIApplication.shared.delegate as!
                 AppDelegate).saveContext()
                tableView.reloadData()
            }
        } else {
            if indexPath.row > 0 && indexPath.row <= boughtListItems.count {
                let boughtItem = boughtListItems[indexPath.row - 1]
                let listItem = ListItem(context: context)
                listItem.id = boughtItem.id
                listItem.desc = boughtItem.desc
                context.delete(boughtItem)
                (UIApplication.shared.delegate as!
                 AppDelegate).saveContext()
                tableView.reloadData()
            }
        }
    }
}

extension ShoppingListViewController: addProductDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func delete(item: ListItem) {
        
    }
}
