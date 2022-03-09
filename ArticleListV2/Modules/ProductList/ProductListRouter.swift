import UIKit

class ProductListRouter {
    
    weak var viewController: UIViewController?
    private var moduleFactory: ModuleFactory?
    
    func createModule(factory: ModuleFactory?) -> UIViewController? {
        moduleFactory = factory
        let view = factory?.makeProductListModule(router: self)
        viewController = view
        view?.title = "products_title".localizedString
        return view
    }

}

extension ProductListRouter: ProductListWireframeProtocol {
    
    func showShoppingCartModule(shoppingCart: [ProductEntity]) {
        // Navigate to shopping cart screen. This module is not implemented in this example
//        if case let shoppingCartModule as ShoppingCartViewController = ShoppingCartRouter().createModule(factory: moduleFactory) {
//            shoppingCartModule.presenter?.shoppingCart = shoppingCart
//            viewController?.navigationController?.pushViewController(shoppingCartModule, animated: true)
//        }
    }
    
}
