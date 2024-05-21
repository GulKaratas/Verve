import UIKit

class ToBuyItemCell: UITableViewCell {
    
    @IBOutlet weak var lblDesc: UILabel!
    
   
    var cellIsSelected: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
