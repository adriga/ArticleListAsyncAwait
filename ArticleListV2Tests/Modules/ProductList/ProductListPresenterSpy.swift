import XCTest
@testable import ArticleListV2

class ProductListPresenterSpy: ProductListInteractorOutputProtocol, ShoppingCartInteractorOutputProtocol {

    var productsOk: Bool = false
    var products: [ProductEntity] = [ProductEntity]()
    var productsError: Bool = false
    var updateCart: Bool = false
    var totalCartAmountIsZero: Bool = false
    var updateTotalCartAmount: Bool = false

    var asyncExpectation: XCTestExpectation?
    
    func productsDidLoad(products: [ProductEntity]) {
        self.products = products
        productsOk = true
    }
    
    func getProductsError() {
        self.products = [ProductEntity]()
        productsError = true
    }
    
    func updateCart(cartProducts: [ProductEntity]?) {
        updateCart = true
    }
    
    func updateTotalCartAmount(_ cartAmount: Double) {
        if cartAmount == 0 {
            totalCartAmountIsZero = true
        }
        updateTotalCartAmount = true
    }
}
