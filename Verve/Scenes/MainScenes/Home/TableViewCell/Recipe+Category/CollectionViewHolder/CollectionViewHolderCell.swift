import UIKit

class CollectionViewHolderCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let api = APIManager.shared
    var recipes = [Recipe]()
    var mealTypeString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecipeCell.nibFile, forCellWithReuseIdentifier: RecipeCell.identifier)
        let customFlowLayout = UICollectionViewFlowLayout()
        customFlowLayout.minimumLineSpacing = 20
        customFlowLayout.scrollDirection = .horizontal
        customFlowLayout.itemSize = CGSize(width:160, height:300)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = customFlowLayout
        collectionView.backgroundColor = .clear
    }
}

extension CollectionViewHolderCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentRecipe = recipes[indexPath.item]
        if let recipeLink = URL(string: currentRecipe.sourceUrl) {
            UIApplication.shared.open(recipeLink)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension CollectionViewHolderCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as? RecipeCell else { return UICollectionViewCell() }
        
        let currentRecipe = recipes[indexPath.row]
        let imageUrl = currentRecipe.image
        
        cell.configureCell(with: currentRecipe, imageUrl: imageUrl)
        
        return cell
    }
}
