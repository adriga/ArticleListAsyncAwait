import Foundation

protocol ShoppingCartInteractorInputProtocol: AnyObject {
    
    /* Presenter -> Interactor */
    func addProductToCart(product: ProductEntity)
    func getTotalCartAmount()
}

protocol ShoppingCartInteractorOutputProtocol: AnyObject {
    
    /* Interactor -> Presenter */
    func updateCart(cartProducts: [ProductEntity]?)
    func updateTotalCartAmount(_ cartAmount: Double)
}

class ShoppingCartInteractor: AsyncInteractor {
    
    weak var presenter: ShoppingCartInteractorOutputProtocol?
    var shoppingCart: [ProductEntity]?
}

extension ShoppingCartInteractor: ShoppingCartInteractorInputProtocol {
    
    func addProductToCart(product: ProductEntity) {
        executeInBackground {
            if self.shoppingCart != nil {
                self.shoppingCart?.append(product)
            } else {
                self.shoppingCart = [product]
            }
        } completionInMainThread: { _ in
            self.presenter?.updateCart(cartProducts: self.shoppingCart)
        }
    }
    
    func getTotalCartAmount() {
        executeInBackground {
            self.calculateKeychainsAmount() + self.calculateTshirtsAmount() + self.calculateMugsAmount()
        } completionInMainThread: { cartAmount in
            self.presenter?.updateTotalCartAmount(cartAmount ?? 0.0)
        }
    }
}

extension ShoppingCartInteractor {

    func calculateKeychainsAmount() -> Double {
        if let shoppingCart = shoppingCart {
            let keychains = shoppingCart.filter( { $0.code == "KEYCHAIN" } )
            if let firstKeychain = keychains.first, let keychainPrice = Double(firstKeychain.price) {
                if keychains.count % 2 == 0 {
                    return keychainPrice * Double(keychains.count) / 2
                } else {
                    return (keychainPrice * Double(keychains.count - 1) / 2) + keychainPrice
                }
            }
        }
        return 0
    }
    
    func calculateTshirtsAmount() -> Double {
        if let shoppingCart = shoppingCart {
            let tshirts = shoppingCart.filter( { $0.code == "TSHIRT" } )
            if let firstTshirt = tshirts.first, let tshirtPrice = Double(firstTshirt.price) {
                if tshirts.count >= 3 {
                    return tshirtPrice * Double(tshirts.count) - tshirtPrice * Double(tshirts.count) * 5/100
                } else {
                    return tshirtPrice * Double(tshirts.count)
                }
            }
        }
        return 0
    }
    
    func calculateMugsAmount() -> Double {
        if let shoppingCart = shoppingCart {
            let mugs = shoppingCart.filter( { $0.code == "MUG" } )
            if let firstMug = mugs.first, let mugPrice = Double(firstMug.price) {
                return mugPrice * Double(mugs.count)
            }
        }
        return 0
    }
}
