import XCTest
@testable import ArticleListV2

class ProductListViewSpy: ProductListViewProtocol {
    
    var reloadProducts: Bool = false
    var showNotProducts: Bool = false
    var showCart: Bool = false
    var hideCart: Bool = false
    var setCartProductsCount: Bool = false
    var setCartAmount: Bool = false
    
    var presenter: ProductListPresenterProtocol?

    func configureView() {}
    
    func reloadProducts(products: [ProductViewEntity]) {
        reloadProducts = true
    }
    
    func showNotProductsView() {
        showNotProducts = true
    }
    
    func showCartView() {
        showCart = true
    }
    
    func hideCartView() {
        hideCart = true
    }
    
    func setCartProductsCount(_ cartCount: Int) {
        setCartProductsCount = true
    }
    
    func setCartAmount(_ cartAmount: Double) {
        setCartAmount = true
    }
}
