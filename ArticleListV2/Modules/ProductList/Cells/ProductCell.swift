import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productName.font = UIFont.boldFont(ofSize: 17)
        productName.textColor = .mediumLabelColor
        productPrice.font = UIFont.mediumFont(ofSize: 15)
        productPrice.textColor = .mediumLabelColor
        offerLabel.font = UIFont.regularFont(ofSize: 12)
        offerLabel.textColor = .mediumLabelColor
    }
    
    public func configureProductCell(product: ProductViewEntity) {
        if let image = product.image {
            productImage.image = UIImage(named: image)
        }
        if let offer = product.offer {
            offerLabel.isHidden = false
            offerLabel.text = offer
        } else {
            offerLabel.isHidden = true
        }
        productName.text = product.name
        productName.accessibilityIdentifier = product.name
        productPrice.text = product.price + "€"
    }
}
