import XCTest
@testable import ArticleListV2

class ProductListPresenterTests: XCTestCase {

    var sut: ProductListPresenter!
    var routerSpy: ProductListRouterSpy!
    var viewSpy: ProductListViewSpy!
    
    override func setUp() {
        super.setUp()
        sut = ProductListPresenter()
        routerSpy = ProductListRouterSpy()
        viewSpy = ProductListViewSpy()
        sut.router = routerSpy
        sut.view = viewSpy
    }
    
    func test_shoppingCartClicked_andCartHasProducts_shouldShowShoppingCartModule() {
        // Given
        sut.shoppingCart = [ProductEntity(code: "KEYCHAIN", name: "Key Chain", price: "5")]
        
        // When
        sut.shoppingCartClicked()
        
        // Then
        XCTAssertTrue(routerSpy.showShoppingCartModule)
    }
    
    func test_shoppingCartClicked_andNoProductsInCart_shouldNotShowShoppingCartModule() {
        // Given
        sut.shoppingCart = nil
        
        // When
        sut.shoppingCartClicked()
        
        // Then
        XCTAssertFalse(routerSpy.showShoppingCartModule)
    }
    
    func test_productsDidLoad_shouldReloadProductsList() {
        // When
        sut.productsDidLoad(products: [ProductEntity(code: "KEYCHAIN", name: "Key Chain", price: "5")])
        
        // Then
        XCTAssertTrue(viewSpy.reloadProducts)
    }
    
    func test_getProductsError_shouldShowNotProductsView() {
        // When
        sut.getProductsError()
        
        // Then
        XCTAssertTrue(viewSpy.showNotProducts)
    }
    
    func test_updateCart_withSomeProducts_shouldShowCartView_andRefreshCartProductsCount() {
        // When
        sut.updateCart(cartProducts: [ProductEntity(code: "KEYCHAIN", name: "Key Chain", price: "5")])
        
        // Then
        XCTAssertTrue(viewSpy.showCart)
        XCTAssertTrue(viewSpy.setCartProductsCount)
    }
    
    func test_updateCart_withNoProducts_shouldHideCartView() {
        // When
        sut.updateCart(cartProducts: nil)
        
        // Then
        XCTAssertTrue(viewSpy.hideCart)
    }
    
    func test_updateTotalCartAmount_shouldRefreshCartAmountInView() {
        // When
        sut.updateTotalCartAmount(5)
        
        // Then
        XCTAssertTrue(viewSpy.setCartAmount)
    }
}
