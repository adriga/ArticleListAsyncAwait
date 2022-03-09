import XCTest
@testable import ArticleListV2

class ProductListInteractorTests: XCTestCase {
    
    var sut: ProductListInteractor!
    var presenterSpy: ProductListPresenterSpy!
    var networkManagerMock = NetworkManagerMock()
    
    override func setUp() {
        super.setUp()
        sut = ProductListInteractor(networkManager: networkManagerMock)
        presenterSpy = ProductListPresenterSpy()
        sut.presenter = presenterSpy
    }
    
    func test_getAllProducts_withSuccessReponse_shouldReturnProducts() {
        // When
        sut.getAllProducts()
        waitForAsyncExpectations()
        
        // Then
        XCTAssertTrue(presenterSpy.productsOk)
        XCTAssertEqual(presenterSpy.products.count, 2)
    }
    
    func test_getAllProducts_withErrorReponse_shouldCallGetProductsError() {
        // Given
        networkManagerMock.returnError = true
        
        // When
        sut.getAllProducts()
        waitForAsyncExpectations()
        
        // Then
        XCTAssertTrue(presenterSpy.productsError)
        XCTAssertEqual(presenterSpy.products.count, 0)
    }
}

