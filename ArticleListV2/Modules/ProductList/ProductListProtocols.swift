import Foundation

// MARK: Router
protocol ProductListWireframeProtocol {
    
    func showShoppingCartModule(shoppingCart: [ProductEntity])
}

// MARK: View
protocol ProductListViewProtocol: AnyObject {
    
    var presenter: ProductListPresenterProtocol? { get set }
    
    /* Presenter -> ViewController */
    func configureView()
    func reloadProducts(products: [ProductViewEntity])
    func showNotProductsView()
    func showCartView()
    func hideCartView()
    func setCartProductsCount(_ cartCount: Int)
    func setCartAmount(_ cartAmount: Double)
}

// MARK: Presenter
protocol ProductListPresenterProtocol {
    
    /* ViewController -> Presenter */
    func viewDidLoad()
    func reloadProducts()
    func didSelectProduct(product: ProductEntity)
    func shoppingCartClicked()
}
