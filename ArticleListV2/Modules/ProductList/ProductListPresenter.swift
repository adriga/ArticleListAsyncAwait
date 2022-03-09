import Foundation

class ProductListPresenter {
    
    weak var view: ProductListViewProtocol?
    var productListInteractor: ProductListInteractorInputProtocol?
    var shoppingCartInteractor: ShoppingCartInteractorInputProtocol?
    var router: ProductListWireframeProtocol?
    
    var shoppingCart: [ProductEntity]?
}

extension ProductListPresenter: ProductListPresenterProtocol {
    
    func viewDidLoad() {
        view?.configureView()
        productListInteractor?.getAllProducts()
    }
    
    func reloadProducts() {
        productListInteractor?.getAllProducts()
    }
    
    func didSelectProduct(product: ProductEntity) {
        shoppingCartInteractor?.addProductToCart(product: product)
        shoppingCartInteractor?.getTotalCartAmount()
    }
    
    func shoppingCartClicked() {
        if let shoppingCart = shoppingCart {
            router?.showShoppingCartModule(shoppingCart: shoppingCart)
        }
    }
}

extension ProductListPresenter: ProductListInteractorOutputProtocol {
    
    func productsDidLoad(products: [ProductEntity]) {
        view?.reloadProducts(products: products.map({ ProductViewEntity(entity: $0) }))
    }
    
    func getProductsError() {
        view?.showNotProductsView()
    }
}

extension ProductListPresenter: ShoppingCartInteractorOutputProtocol {
    
    func updateCart(cartProducts: [ProductEntity]?) {
        shoppingCart = cartProducts
        if let cart = cartProducts, cart.count > 0 {
            view?.showCartView()
            view?.setCartProductsCount(cart.count)
        } else {
            view?.hideCartView()
        }
    }
    
    func updateTotalCartAmount(_ cartAmount: Double) {
        view?.setCartAmount(cartAmount)
    }
}
