//
//  FridgeViewController.swift
//  Verve
//
//  CCreated by Gül Karataş on 8.05.2024.
//

import UIKit

final class FridgeViewController: UIViewController {
    
    private lazy var mainLbl: UILabel = {
        let mainLbl = UILabel()
        mainLbl.text = LabelText.fridgePageMain.rawValue
        mainLbl.textColor = UIColor(hexString: Color.main.rawValue)
        mainLbl.font = UIFont.boldSystemFont(ofSize: 25)
        mainLbl.textAlignment = .center
        view.addSubview(mainLbl)
        return mainLbl
    }()
    
    private lazy var enterIngredientView: UIView = {
        let enterIngredientView = UIView()
        enterIngredientView.layer.cornerRadius = CornerRadius.cell_bigSize.rawValue
        enterIngredientView.layer.borderWidth = 1
        enterIngredientView.layer.borderColor = UIColor(hexString: Color.cell.rawValue).cgColor
        enterIngredientView.backgroundColor = UIColor(hexString: Color.border.rawValue)
        enterIngredientView.clipsToBounds = true
        view.addSubview(enterIngredientView)
        return enterIngredientView
    }()
    
    private lazy var enterIngredientField: UITextField = {
        let enterIngredientField = UITextField()
        enterIngredientField.delegate = self
        enterIngredientField.attributedPlaceholder = NSAttributedString(string: " Enter Ingredients: apple,onion...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: Color.secondary.rawValue)])
        enterIngredientField.textColor = UIColor(hexString: Color.main.rawValue)
        enterIngredientField.font = UIFont.boldSystemFont(ofSize: 16)
        enterIngredientField.clipsToBounds = true
        enterIngredientView.addSubview(enterIngredientField)
        return enterIngredientField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        return tableView
    }()
    
    private lazy var seeRecipesButton: UIButton = {
        let seeRecipesButton = UIButton()
        seeRecipesButton.setImage(UIImage(named: "search-icon"), for: .normal)
        seeRecipesButton.imageView?.contentMode = .scaleAspectFill
        seeRecipesButton.layer.cornerRadius = CornerRadius.cell_bigSize.rawValue
        seeRecipesButton.backgroundColor = UIColor(hexString: Color.main.rawValue)
        view.addSubview(seeRecipesButton)
        return seeRecipesButton
    }()
    
    private var api = APIManager.shared
    private var ingredientsByCategory = [IngredientCategory]()
    private var ingredientsStringArray = [String]()
    
    
    private let constraintFromTop: CGFloat = 20
    private let constraintFromLeft: CGFloat = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpTableView()
        fetchData()
        addSeeRecipeBtnNotification()
    }
    
    
    private func setUp() {
        setUpView()
        addMainLbl()
        addEnterIngredient()
        addTableView()
        addSeeRecipesTap()
    }
    
    private func setUpView() {
        view.backgroundColor = UIColor(hexString: Color.background.rawValue)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IngCollectionViewHolderCell.nibFile, forCellReuseIdentifier: IngCollectionViewHolderCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
    }
    
   
    private func addEnterIngredient() {
        addEnterIngredientView()
        addEnterIngredientField()
    }
    
    private func addMainLbl() {
        mainLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: mainLbl, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: mainLbl, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 10)
        let right = NSLayoutConstraint(item: mainLbl, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10)
        
        NSLayoutConstraint.activate([top, left, right])
        
    }
    
    private func addEnterIngredientView() {
        enterIngredientView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: enterIngredientView, attribute: .top, relatedBy: .equal, toItem: mainLbl, attribute: .bottom, multiplier: 1, constant: constraintFromTop)
        let left = NSLayoutConstraint(item: enterIngredientView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: constraintFromLeft)
        let width = NSLayoutConstraint(item: enterIngredientView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.width - constraintFromLeft * 2)
        let height = NSLayoutConstraint(item: enterIngredientView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        
        NSLayoutConstraint.activate([top, left, width, height])
    }
    
    private func addEnterIngredientField() {
        enterIngredientField.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: enterIngredientField, attribute: .top, relatedBy: .equal, toItem: enterIngredientView, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: enterIngredientField, attribute: .left, relatedBy: .equal, toItem: enterIngredientView, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: enterIngredientField, attribute: .right, relatedBy: .equal, toItem: enterIngredientView, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: enterIngredientField, attribute: .bottom, relatedBy: .equal, toItem: enterIngredientView, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, left, right, bottom])
    }
    
    private func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: enterIngredientView, attribute: .bottom, multiplier: 1, constant: 10)
        let left = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, left, right, bottom])
    }
    
    private func  addSeeRecipesButton() {
        seeRecipesButton.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: seeRecipesButton, attribute: .top, relatedBy: .equal, toItem: mainLbl, attribute: .bottom, multiplier: 1, constant: constraintFromTop)
        let left = NSLayoutConstraint(item: seeRecipesButton, attribute: .left, relatedBy: .equal, toItem: enterIngredientView, attribute: .right, multiplier: 1, constant: 20)
        let right = NSLayoutConstraint(item: seeRecipesButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20)
        let height = NSLayoutConstraint(item: seeRecipesButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        
        
        NSLayoutConstraint.activate([top, left, right, height])
    }
    
    // MARK: - API functions
    private func fetchData() {
        let url = APIurlsGenerator.urlForIngredientsByCategory()
        
        api.getData(with: url) { (result: IngredientsByCategory?, error) in
            guard let result = result else {
                print("Couldn't fetch data")
                return
            }
            DispatchQueue.main.async {
                self.ingredientsByCategory = result.results
                self.tableView.reloadData()
            }
        }
    }
    
   
    private func addSeeRecipeBtnNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(addSeeRecipesBtn), name: Notification.Name("Verve.Notification.addButton"), object: nil)
    }
    
    @objc private func addSeeRecipesBtn() {
        view.endEditing(true)
        self.changeTxtFieldWidth()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.80) {
            self.addSeeRecipesButton()
        }
    }
    
    
    private func addSeeRecipesTap() {
        seeRecipesButton.addTarget(self, action: #selector(seeRecipesTapped), for: .touchUpInside)
    }
    
    @objc private func seeRecipesTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: RecipesViewController.identifier) as? RecipesViewController else { return }
        
        vc.ingredientsArray = self.ingredientsStringArray
        vc.enteredIngredientsString = self.enterIngredientField.text!
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func changeTxtFieldWidth() {
        enterIngredientView.widthAnchor.constraint(equalToConstant: view.frame.width / 2 + 50).isActive = true
        UIView.animate(withDuration: 0.75) {
            self.enterIngredientView.layoutIfNeeded()
        }
    }
}


extension FridgeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FridgeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientsByCategory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngCollectionViewHolderCell.identifier, for: indexPath) as? IngCollectionViewHolderCell else { return UITableViewCell() }
        
        let currentCategory = ingredientsByCategory[indexPath.row]
        let imageUrl = currentCategory.image
        cell.configureCell(with: currentCategory, imageUrl: imageUrl)
        cell.delegate = self
        cell.collectionView.reloadData()
        
        return cell
    }
}

extension FridgeViewController: IngCollectionViewHolderCellDelegate {
    func didSelectItem(with ingredient: Ingredient) {
        if !ingredient.isSelected {
            print(ingredient.name)
            ingredientsStringArray.append(ingredient.name)
            print(ingredientsStringArray)
        } else {
            var indexNeeded = 0
            for index in 0..<ingredientsStringArray.count {
                if ingredientsStringArray[index] == ingredient.name {
                    indexNeeded = index
                }
            }
            ingredientsStringArray.remove(at: indexNeeded)
            print(ingredientsStringArray)
        }
    }
}

extension FridgeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.changeTxtFieldWidth()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.80) {
            self.addSeeRecipesButton()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
