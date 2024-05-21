//
//  MyRecipeCell.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit
import CoreData


class MyRecipeCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
   
    
    private func setUp() {
        configCellView()
        configImg()
        configTitle()
    }
    
   
    
    private func configCellView() {
        cellView.layer.cornerRadius = CornerRadius.image_cell.rawValue
        cellView.backgroundColor = UIColor(hexString: Color.border.rawValue)
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor(hexString: Color.border.rawValue).cgColor
    }
    
    private func configImg() {
        recipeImg.layer.cornerRadius = CornerRadius.image_cell.rawValue
        recipeImg.contentMode = .scaleAspectFill
    }
    
    private func configTitle() {
        recipeName.textColor = UIColor(hexString: Color.main.rawValue)
        ingredientsLbl.textColor = UIColor(hexString: Color.secondary.rawValue)
    }
}
