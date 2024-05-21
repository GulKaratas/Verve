//
//  RecipeDetailsViewController.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit


final class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet private weak var recipeTitle: UILabel!
    @IBOutlet private weak var usedIngLbl: UILabel!
    @IBOutlet private weak var missedIngLbl: UILabel!
    @IBOutlet private weak var collectionViewForUsed: UICollectionView!
    @IBOutlet private weak var collectionViewForMissed: UICollectionView!
    
    
    var recipe: RecipeByIngredients!
    var usedIngredients = [UsedIngredient]()
    var missedIngredients = [MissedIngredient]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpCollectionViewForUsed()
        setUpCollectionViewForMissed()
    }
    
    
   
    
    private func setUp() {
        setUpView()
        setUpLbls()
    }
    
    private func setUpView() {
        view.backgroundColor = UIColor(hexString: Color.background.rawValue)
        recipeImage.contentMode = .scaleAspectFill
    }
    
    private func setUpLbls() {
        usedIngLbl.text = LabelText.usedIngredients.rawValue
        usedIngLbl.textColor = UIColor(hexString: Color.main.rawValue)
        missedIngLbl.text = LabelText.missedIngredients.rawValue
        missedIngLbl.textColor = UIColor(hexString: Color.main.rawValue)
        recipeTitle.text = recipe?.title
        recipeTitle.textColor = UIColor(hexString: Color.main.rawValue)
        recipeImage.load(url: URL(string: recipe.image)!)
    }
    
    private func setUpCollectionViewForUsed() {
        setUpCollectionView(collectionView: collectionViewForUsed)
    }
    
    private func setUpCollectionViewForMissed() {
        setUpCollectionView(collectionView: collectionViewForMissed)
    }
    
    private func setUpCollectionView(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailsIngredientCell.nibFile, forCellWithReuseIdentifier: DetailsIngredientCell.identifier)
        let customFlowLayout = UICollectionViewFlowLayout()
        customFlowLayout.minimumLineSpacing = 15
        customFlowLayout.itemSize = CGSize(width:110, height:130)
        customFlowLayout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.collectionViewLayout = customFlowLayout
        collectionView.backgroundColor = .clear
    }
      
    
    
}



extension RecipeDetailsViewController: UICollectionViewDelegate {
    
}

extension RecipeDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewForUsed {
            return usedIngredients.count
        } else if collectionView == self.collectionViewForMissed {
            return missedIngredients.count
        }
        return max(usedIngredients.count, missedIngredients.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsIngredientCell.identifier, for: indexPath) as? DetailsIngredientCell else { return UICollectionViewCell()}
       
        
        if collectionView == self.collectionViewForUsed {
            let currentUsedIngredient = usedIngredients[indexPath.row]
            let imageUrlForUsed = currentUsedIngredient.image
           
            //UserDefaults
            UserDefaults.standard.set(imageUrlForUsed, forKey: "imageUrlForUsed")
            
            cell.ingredientName.text = currentUsedIngredient.name.firstLetterUppercased()
            cell.ingredientImg.load(url: URL(string: imageUrlForUsed)!)
        } else if collectionView == self.collectionViewForMissed {
            let currentMissedIngredient = missedIngredients[indexPath.row]
            let imageUrlForMissed = currentMissedIngredient.image
            cell.ingredientName.text = currentMissedIngredient.name.firstLetterUppercased()
            cell.ingredientImg.load(url: URL(string: imageUrlForMissed)!)
        }
        return cell
    }
}
