import XCTest
@testable import ArticleListV2

class ShoppingCartInteractorTests: XCTestCase {
    
    var sut: ShoppingCartInteractor!
    var presenterSpy: ProductListPresenterSpy!

    override func setUp() {
        super.setUp()
        sut = ShoppingCartInteractor()
        presenterSpy = ProductListPresenterSpy()
        sut.presenter = presenterSpy
    }
    
    func test_addProductToCart_shouldRefreshCart_withNewProduct() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Key Chain", price: "5")
        sut.shoppingCart = [mockProduct]
        
        // When
        sut.addProductToCart(product: ProductEntity(code: "TSHIRT", name: "T-Shirt", price: "20"))
        waitForAsyncExpectations()
        
        // Then
        XCTAssertTrue(presenterSpy.updateCart)
        XCTAssertEqual(sut.shoppingCart?.count, 2)
    }
    
    func test_getTotalCartAmount_withEmptyCart_shouldUpdateCartAmountWithZero() {
        // Given
        sut.shoppingCart = nil
        
        // When
        sut.getTotalCartAmount()
        waitForAsyncExpectations()
        
        // Then
        XCTAssertTrue(presenterSpy.updateTotalCartAmount)
        XCTAssertTrue(presenterSpy.totalCartAmountIsZero)
    }
    
    func test_getTotalCartAmount_withValidCart() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Key Chain", price: "5")
        sut.shoppingCart = [mockProduct]
        
        // When
        sut.getTotalCartAmount()
        waitForAsyncExpectations()
        
        // Then
        XCTAssertTrue(presenterSpy.updateTotalCartAmount)
        XCTAssertFalse(presenterSpy.totalCartAmountIsZero)
    }
    
    func test_getKeychainCartAmount_withEmptyCart_shouldReturnZero() {
        // Given
        sut.shoppingCart = []
        
        // When
        let keychainsAmount = sut.calculateKeychainsAmount()
        
        // Then
        XCTAssertEqual(keychainsAmount, 0)
    }
    
    func test_getKeychainCartAmount_withCartWithoutKeychains_shouldReturnZero() {
        // Given
        let mockProduct = ProductEntity(code: "TSHIRT", name: "T-Shirt", price: "20")
        sut.shoppingCart = [mockProduct]
        
        // When
        let keychainsAmount = sut.calculateKeychainsAmount()
        
        // Then
        XCTAssertEqual(keychainsAmount, 0)
    }
    
    func test_getKeychainCartAmount_withInvalidCart_shouldReturnZero() {
        // Given
        sut.shoppingCart = nil
        
        // When
        let keychainsAmount = sut.calculateKeychainsAmount()
        
        // Then
        XCTAssertEqual(keychainsAmount, 0)
    }
    
    func test_getKeychainCartAmount_withOneKeychainInTheCart_shouldReturnCorrectAmount() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Key Chain", price: "5")
        sut.shoppingCart = [mockProduct]
        
        // When
        let keychainsAmount = sut.calculateKeychainsAmount()
        
        // Then
        XCTAssertEqual(keychainsAmount, 5)
    }
    
    func test_getKeychainCartAmount_withTwoKeychainsInTheCart_shouldReturnCorrectAmount() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Key Chain", price: "5")
        sut.shoppingCart = [mockProduct, mockProduct]
        
        // When
        let keychainsAmount = sut.calculateKeychainsAmount()
        
        // Then
        XCTAssertEqual(keychainsAmount, 5)
    }
    
    func test_getKeychainCartAmount_withThreeKeychainsInTheCart_shouldReturnCorrectAmount() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Key Chain", price: "5")
        sut.shoppingCart = [mockProduct, mockProduct, mockProduct]
        
        // When
        let keychainsAmount = sut.calculateKeychainsAmount()
        
        // Then
        XCTAssertEqual(keychainsAmount, 10)
    }
    
    func test_getTshirtCartAmount_withOneTshirtInTheCart() {
        // Given
        let mockProduct = ProductEntity(code: "TSHIRT", name: "T-Shirt", price: "20")
        sut.shoppingCart = [mockProduct]
        
        // Then
        XCTAssertEqual(sut.calculateTshirtsAmount(), 20)
    }
    
    func test_getTshirtCartAmount_withThreeTshirtInTheCart() {
        // Given
        let mockProduct = ProductEntity(code: "TSHIRT", name: "T-Shirt", price: "20")
        sut.shoppingCart = [mockProduct, mockProduct, mockProduct]
        
        // Then
        XCTAssertEqual(sut.calculateTshirtsAmount(), 57)
    }
}
