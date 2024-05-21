//
//  DetailsIngredientCell.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit

class DetailsIngredientCell: UICollectionViewCell {

    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var ingredientImg: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientImg.contentMode = .scaleAspectFill
        ingredientImg.layer.cornerRadius = CornerRadius.cell_bigSize.rawValue
        cellView.backgroundColor = UIColor(hexString: Color.border.rawValue)
        cellView.layer.cornerRadius = CornerRadius.cell_bigSize.rawValue
        ingredientName.textColor = UIColor(hexString: Color.main.rawValue)
    }

    
}
