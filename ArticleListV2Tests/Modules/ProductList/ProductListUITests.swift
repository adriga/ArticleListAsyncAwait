import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
import KIF
@testable import ArticleListV2

class ProductListUITests: KIFTestCase {

    var moduleFactory = ModuleDependencyContainer()

    override func beforeEach() {
        super.beforeEach()
        if let productListModule = ProductListRouter().createModule(factory: moduleFactory) as? ProductListViewController {
            UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: productListModule)
        }
    }

    override func afterEach() {
        HTTPStubs.removeAllStubs()
        super.afterEach()
    }

    func test_viewDidLoad_withProductsErrorResponse_shouldShowNoProductsView() {
        // Given
        // Mock GET request Error
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json") && isMethodGET()) { _ in
            return HTTPStubsResponse(jsonObject: [String: Any](), statusCode: 500, headers: nil)
        }

        // Then
        tester().waitForView(withAccessibilityIdentifier: NSLocalizedString("no_products", comment: ""))
    }

    func test_viewDidLoad_withProductsSuccessResponse_shouldShowProducts() {
        // Given
        // Mock GET request OK
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json") && isMethodGET()) { _ in
            let obj = ["products": [["code": "KEYCHAIN", "name": "Key Chain", "price": 5],
                                    ["code": "TSHIRT", "name": "T-Shirt", "price": 20],
                                    ["code": "MUG", "name": "Coffee Mug", "price": 7.5]]] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }

        // Then
        tester().waitForView(withAccessibilityIdentifier: "Key Chain")
    }

    func test_whenClickOnAProdut_itShouldBeAddedToCart() {
        // Given
        // Mock GET request OK
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json") && isMethodGET()) { _ in
            let obj = ["products": [["code": "KEYCHAIN", "name": "Key Chain", "price": 5],
                                    ["code": "TSHIRT", "name": "T-Shirt", "price": 20],
                                    ["code": "MUG", "name": "Coffee Mug", "price": 7.5]]] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }

        // When
        tester().tapRow(at: IndexPath(item: 0, section: 0), inTableViewWithAccessibilityIdentifier: "ProductList")

        // Then
        if let productsInCart = tester().waitForView(withAccessibilityIdentifier: "cartProductsLabel") as? UILabel {
            XCTAssertEqual(productsInCart.text, String(format: NSLocalizedString("shopping_cart_products", comment: ""), 1))
        }
    }
    
    // e2e test that makes a real server request (without mocks)
    func test_viewDidLoad_shouldShowProducts() {
        tester().waitForView(withAccessibilityIdentifier: "ProductCell")
    }
}
