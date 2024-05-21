//
//  IngCollectionViewHolderCell.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

protocol IngCollectionViewHolderCellDelegate: AnyObject {
    func didSelectItem(with ingredient: Ingredient)
}

class IngCollectionViewHolderCell: UITableViewCell {
    
    // Category
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var ingredientsCount: UILabel!
    // Ingredients
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ingredients = [Ingredient]()
    weak var delegate: IngCollectionViewHolderCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCategory()
        configCellView()
        setUpCollectionView()
    }
   
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    
   
   
    func configureCell(with category: IngredientCategory, imageUrl: String) {
        self.categoryTitle.text = category.title
        self.categoryTitle.textColor = UIColor(hexString: Color.main.rawValue)
        self.categoryImg.load(url: URL(string: imageUrl)!)
        self.ingredients = category.ingredients.map { Ingredient(name: $0) }
        self.ingredientsCount.text = "\(category.ingredients.count) Ingredients"
        self.ingredientsCount.textColor = UIColor(hexString: Color.secondary.rawValue)
        self.backgroundColor = .clear
    }
    
    private func configureCategory() {
        categoryView.layer.cornerRadius = CornerRadius.image_cell.rawValue
        categoryView.backgroundColor = UIColor(hexString: Color.cell.rawValue)
        categoryImg.layer.cornerRadius = CornerRadius.image_cell.rawValue
    }
    
    private func configCellView() {
        cellView.layer.cornerRadius = CornerRadius.cell_smallSize.rawValue
        cellView.backgroundColor = UIColor(hexString: Color.background.rawValue)
    }
    
    private func setUpCollectionView() {
       
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IngredientCell.nibFile, forCellWithReuseIdentifier: IngredientCell.identifier)
        let customFlowLayout = UICollectionViewFlowLayout()
        customFlowLayout.minimumInteritemSpacing = 5
        customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        customFlowLayout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true

        collectionView.collectionViewLayout = customFlowLayout
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    
    
    
    private func addSeeRecipesButton() {
        NotificationCenter.default.post(name: Notification.Name("Verve.Notification.addButton"), object: nil)
    }
}



// Delegate
extension IngCollectionViewHolderCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentIngredient = ingredients[indexPath.row]
        delegate?.didSelectItem(with: currentIngredient)
        currentIngredient.isSelected.toggle()
        collectionView.reloadData()
        addSeeRecipesButton()
    }
}

// Data Source
extension IngCollectionViewHolderCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCell.identifier, for: indexPath) as? IngredientCell else { return UICollectionViewCell() }
        
        let currentIngredient = ingredients[indexPath.row]
        cell.configureCell(with: currentIngredient)
        
        return cell
    }
    
    
}
