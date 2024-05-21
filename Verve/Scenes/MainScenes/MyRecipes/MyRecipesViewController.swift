//
//  MyRecipesViewController.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit
import CoreData


public var myRecipes = [MyRecipe]()

final class MyRecipesViewController: UIViewController {
    
    private lazy var mainLbl: UILabel = {
        let mainLbl = UILabel()
        mainLbl.text = LabelText.myRecipesPageMain.rawValue
        mainLbl.textColor = UIColor(hexString: Color.main.rawValue)
        mainLbl.font = UIFont.boldSystemFont(ofSize: 25)
        mainLbl.textAlignment = .center
        view.addSubview(mainLbl)
        return mainLbl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        return tableView
    }()
    
    
   private func nonDeletedRecipes() -> [MyRecipe] {
        
        var nonDeletedRecipes = [MyRecipe]()
       myRecipes.forEach { myRecipe in
            if myRecipe.deletedData == nil {
                nonDeletedRecipes.append(myRecipe)
            }
        }
        return nonDeletedRecipes
    }
    
    var firsLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveData()
        setUp()
        setUpTableView()
        addRecipe()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    private func setUp() {
        setUpView()
        addMainLbl()
        addTableView()
        
    }
    
    private func setUpView() {
        self.view.backgroundColor = UIColor(hexString: Color.background.rawValue)
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: Color.main.rawValue)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyRecipeCell.nibFile, forCellReuseIdentifier: MyRecipeCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
    }
    
    
    
    private func addMainLbl() {
        mainLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: mainLbl, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: mainLbl, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 10)
        let right = NSLayoutConstraint(item: mainLbl, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10)
        
        NSLayoutConstraint.activate([top, left, right])
     }
    
    private func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: mainLbl, attribute: .bottom, multiplier: 1, constant: 50)
        let left = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, left, right, bottom])
    }
    
   
    //tapbar buton
    private func addRecipe() {
        navigationItem.rightBarButtonItem = UIBarButtonItem( barButtonSystemItem: .add, target: self,action: #selector(addRecipeTapped))
    }
    //ekranlar arası geçiş
    @objc private func addRecipeTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: AddEditMyRecipeViewController.identifier) as? AddEditMyRecipeViewController else { return }
        
        vc.delRecipe.isHidden = true
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    private func saveData() {
      
        if firsLoad {
            firsLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyRecipe")
            
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                results.forEach { result in
                    let myRecipe = result as! MyRecipe
                    myRecipes.append(myRecipe)
                }
                
            } catch {
                print("Fetch Failed")
            }
        }
        
        
    }
}



extension MyRecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: AddEditMyRecipeViewController.identifier) as? AddEditMyRecipeViewController else { return }
        
        let indexpath = tableView.indexPathForSelectedRow!
        let selectedRecipe = nonDeletedRecipes()[indexpath.row]
        
        vc.selectedRecipe = selectedRecipe
        
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
                
        tableView.deselectRow(at: indexpath, animated: true)
    }
}

extension MyRecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nonDeletedRecipes().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyRecipeCell.identifier, for: indexPath) as? MyRecipeCell else { return UITableViewCell() }
        
        let currentRecipe = nonDeletedRecipes()[indexPath.row]
        cell.recipeImg.image = currentRecipe.img
        cell.recipeName.text = currentRecipe.name
        cell.ingredientsLbl.text = currentRecipe.ingredients
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
}
