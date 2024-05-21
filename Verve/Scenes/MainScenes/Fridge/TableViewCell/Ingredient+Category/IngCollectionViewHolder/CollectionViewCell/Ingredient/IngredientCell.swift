//
//  IngredientCell.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

class IngredientCell: UICollectionViewCell {

    
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var ingredientName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCellView()
    }
    //malzeme seçilmesine bakarak görünüm
    func configureCell(with ingredient: Ingredient) {
        if ingredient.isSelected {
            cellView.backgroundColor = UIColor(hexString: Color.main.rawValue)
            ingredientName.textColor = UIColor(hexString: Color.border.rawValue)
        } else {
            self.cellView.backgroundColor = UIColor(hexString: Color.border.rawValue)
            self.ingredientName.textColor = UIColor(hexString: Color.main.rawValue)
        }
        self.ingredientName.text = ingredient.name
        self.backgroundColor = .clear
    }
    
    private func configCellView() {
        cellView.layer.cornerRadius = CornerRadius.image_cell.rawValue
    }
}
