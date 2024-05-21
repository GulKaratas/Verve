//
//  RecipesViewController.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

final class RecipesViewController: UIViewController {
    
    private lazy var infoLbl: UILabel = {
        let infoLbl = UILabel()
        infoLbl.text = "Couldn't Find Recipes"
        infoLbl.font = UIFont.boldSystemFont(ofSize: 30)
        infoLbl.textAlignment = .center
        view.addSubview(infoLbl)
        return infoLbl
    }()
    
    private lazy var sorryImage: UIImageView = {
        let sorryImage = UIImageView()
//        sorryImage.image = UIImage.gifImageWithName("sorryGif")
        sorryImage.contentMode = .scaleAspectFill
        view.addSubview(sorryImage)
        return sorryImage
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        return tableView
    }()

    private let api = APIManager.shared
    private var recipes = [RecipeByIngredients]()
    var ingredientsArray = [String]()
    var enteredIngredientsString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpTableView()
        fetchData()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        if recipes.count == 0 {
//            addInfoLbl()
//            addSorryImage()
//        }
//    }
    
   
    
    // MARK: - Configuration Private Functions
    
    private func setUp() {
        setUpView()
        addTableView()
    }
    
    private func setUpView() {
        view.backgroundColor = UIColor(hexString: Color.background.rawValue)
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: Color.main.rawValue)
    }

    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecipeByIngredientsCell.nibFile, forCellReuseIdentifier: RecipeByIngredientsCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
    }
    
    // MARK: - Adding views
    
    private func addInfoLbl() {
        infoLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: infoLbl, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: view.frame.height / 3 - 50)
        let left = NSLayoutConstraint(item: infoLbl, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 30)
        let right = NSLayoutConstraint(item: sorryImage, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10)
        
        NSLayoutConstraint.activate([top, left, right])
    }
    
    private func addSorryImage() {
        sorryImage.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: sorryImage, attribute: .top, relatedBy: .equal, toItem: infoLbl, attribute: .bottom, multiplier: 1, constant: 50)
        let left = NSLayoutConstraint(item: sorryImage, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 80)
        let right = NSLayoutConstraint(item: sorryImage, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -80)
        let height = NSLayoutConstraint(item: sorryImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        
        NSLayoutConstraint.activate([top, left, right, height])
        
    }
    
    
    private func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
        let left = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, left, right, bottom])
    }
    
    private func ingredientsString(from array: [String]) -> String {
        var ingredientsString = ""
        array.forEach { ingredient in
            ingredientsString += "\(ingredient),"
        }
       
        return ingredientsString + enteredIngredientsString
    }
    
    private func fetchData() {
        
        let ingredients = ingredientsString(from: ingredientsArray)
        let url = APIurlsGenerator.urlWithIngredients(ingredients: ingredients)
        
        api.getDataByIngredients(with: url) { (recipes: [RecipeByIngredients]?, error) in
            guard let recipes = recipes else {
                print("couldn't fetch recipes by ingredients")
                return
            }
            DispatchQueue.main.async {
                self.recipes = recipes
                self.tableView.reloadData()
            }
            
        }
    }
}



extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: RecipeDetailsViewController.identifier) as? RecipeDetailsViewController else { return }
        
        let currentRecipe = recipes[indexPath.row]
        
        vc.recipe = currentRecipe
        vc.usedIngredients = currentRecipe.usedIngredients
        vc.missedIngredients = currentRecipe.missedIngredients

        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeByIngredientsCell.identifier, for: indexPath) as? RecipeByIngredientsCell else { return UITableViewCell() }
        
        let currentRecipe = recipes[indexPath.row]
        let imageUrl = currentRecipe.image
        cell.configureCell(with: currentRecipe, imageUrl: imageUrl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}
