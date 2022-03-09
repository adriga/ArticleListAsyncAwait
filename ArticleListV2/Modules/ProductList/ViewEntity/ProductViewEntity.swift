import Foundation

struct ProductViewEntity {
    
    let code: String
    let name: String
    let price: String
    let image: String?
    let offer: String?
    
    init(entity: ProductEntity) {
        code = entity.code
        name = entity.name
        price = entity.price
        if code == "KEYCHAIN" {
            image = "keychain"
            offer = "keychain_discount".localizedString
        } else if code == "TSHIRT" {
            image = "tshirt"
            offer = "tshirt_discount".localizedString
        } else if code == "MUG" {
            image = "mug"
            offer = nil
        } else {
            image = nil
            offer = nil
        }
    }
}
