//
//  HomeViewController.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

final class HomeViewController: UIViewController {    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        return tableView
    }()
    //yemek türü grup
    private var mealData = [MealData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpTableView()
        fetchData()
    }
    

    //görünüm
    private func setUp() {
        setUpView()
        addTableView()
    }
    
    private func setUpView() {
        view.backgroundColor = UIColor(hexString: Color.background.rawValue)
        navigationItem.title = AppName.appName.rawValue
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollectionViewHolderCell.nibFile, forCellReuseIdentifier: CollectionViewHolderCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
    
    private func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, left, right, bottom])
    }
    
    
    
    private func fetchData() {
        let group = DispatchGroup()
        
        MealType.allCases.forEach { mealType in
            let url = APIurlsGenerator.urlWithMealTypes(mealType: mealType.rawValue)
            group.enter()
            APIManager.shared.getData(with: url) { (recipe: RecipeByCategory?, error) in
                guard let recipe = recipe else {
                    print(url)
                    print("couldn't fetch recipes by Categories")
                    return
                }
                self.mealData.append(MealData(title: mealType.rawValue, recipes: recipe.recipes))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        mealData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        mealData[section].title.capitalized
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewHolderCell.identifier, for: indexPath) as? CollectionViewHolderCell else { return UITableViewCell() }
        
        cell.recipes = mealData[indexPath.section].recipes
        cell.collectionView.reloadData()
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
}
