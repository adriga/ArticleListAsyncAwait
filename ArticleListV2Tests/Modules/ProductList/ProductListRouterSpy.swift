import XCTest
@testable import ArticleListV2

class ProductListRouterSpy: ProductListWireframeProtocol {

    var showShoppingCartModule: Bool = false

    func showShoppingCartModule(shoppingCart: [ProductEntity]) {
        showShoppingCartModule = true
    }
}
