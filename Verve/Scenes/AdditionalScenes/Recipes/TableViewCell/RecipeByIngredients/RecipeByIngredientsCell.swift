//
//  RecipeByIngredientsCell.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

class RecipeByIngredientsCell: UITableViewCell {
    
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var usedIngCount: UILabel!
    @IBOutlet weak var missedIngCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellView()
        configureRecipeImg()
        configureLabels()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configureCell(with recipe: RecipeByIngredients, imageUrl: String) {
        self.backgroundColor = .clear
        self.recipeTitle.text = recipe.title
        self.recipeTitle.textColor = UIColor(hexString: Color.main.rawValue)
        self.usedIngCount.text = "\(LabelText.usedIngredients.rawValue) \(recipe.usedIngredientCount)"
        self.missedIngCount.text = "\(LabelText.missedIngredients.rawValue) \(recipe.missedIngredientCount)"
        if URL(string: imageUrl) != nil {
            self.recipeImage.load(url: URL(string: imageUrl)!)
        } else {
            self.recipeImage.image = UIImage(named: AssetName.recipe_default.rawValue)
        }
    }
    
    private func configureCellView() {
        cellView.layer.cornerRadius = CornerRadius.image_cell.rawValue
        cellView.backgroundColor = UIColor(hexString: Color.cell.rawValue)
    }
    
    private func configureRecipeImg() {
        recipeImage.contentMode = .scaleAspectFill
        recipeImage.layer.cornerRadius = CornerRadius.image_cell.rawValue
    }
    
    private func configureLabels() {
        usedIngCount.textColor = UIColor(hexString: Color.secondary.rawValue)
        missedIngCount.textColor = UIColor(hexString: Color.secondary.rawValue)
    }
}
