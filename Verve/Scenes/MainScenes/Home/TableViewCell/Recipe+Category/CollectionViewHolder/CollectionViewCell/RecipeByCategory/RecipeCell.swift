//
//  RecipeCell.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet private weak var recipeTitle: UILabel!
    @IBOutlet private weak var readiInMinutes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    
    
    private func setUp() {
        configCellView()
        configRecipeImage()
        configRecipeTitle()
    }
    
    func configureCell(with recipe: Recipe, imageUrl: String) {
        self.backgroundColor = .clear
        self.readiInMinutes.text = "Ready in \(recipe.readyInMinutes) minutes"
        self.recipeTitle.text = recipe.title
        if URL(string: imageUrl) != nil {
            self.recipeImage.load(url: URL(string: imageUrl)!)
        } else {
            self.recipeImage.image = UIImage(named: AssetName.recipe_default.rawValue)
        }
        
    }
    
    private func configCellView() {
        cellView.layer.cornerRadius = CornerRadius.cell_bigSize.rawValue
        cellView.backgroundColor = UIColor(hexString: Color.cell.rawValue)
        cellView.layer.borderWidth = 1.5
        cellView.layer.borderColor = UIColor(hexString: Color.border.rawValue).cgColor
    }
    
    private func configRecipeImage() {
        recipeImage.contentMode = .scaleAspectFill
        recipeImage.layer.cornerRadius = CornerRadius.image_cell.rawValue
    }
    
    private func configRecipeTitle() {
        recipeTitle.textColor = UIColor(hexString: Color.main.rawValue)
        readiInMinutes.textColor = UIColor(hexString: Color.secondary.rawValue)
    }
}
