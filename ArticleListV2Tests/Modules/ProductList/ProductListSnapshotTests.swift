import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
import KIF
import SnapshotTesting
@testable import ArticleListV2

class ProductListSnapshotTests: XCTestCase {

    var moduleFactory = ModuleDependencyContainer()
    var sut: UIViewController?
    let devices: [String: ViewImageConfig] = ["iPhoneX": .iPhoneX,
                                              "iPhone8": .iPhone8,
                                              "iPhoneSe": .iPhoneSe]
    
    override func setUp() {
        super.setUp()
        if let productListScreen = ProductListRouter().createModule(factory: moduleFactory) as? ProductListViewController {
            UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: productListScreen)
            sut = productListScreen
        }
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func test_snapshot_productListScreenWithProducts() {
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json") && isMethodGET()) { _ in
            let obj = ["products": [["code": "KEYCHAIN", "name": "Key Chain", "price": 5],
                                    ["code": "TSHIRT", "name": "T-Shirt", "price": 20],
                                    ["code": "MUG", "name": "Coffee Mug", "price": 7.5]]] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }
        waitForAsyncExpectations()
        let results = devices.map { device in
            verifySnapshot(matching: sut!,
                           as: .image(on: device.value),
                           named: "WithProducts-\(device.key)",
                           testName: "ProductListScreen")
        }
        results.forEach { XCTAssertNil($0) }
    }
    
    func test_snapshot_productListScreenWithoutProducts() {
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json") && isMethodGET()) { _ in
            return HTTPStubsResponse(jsonObject: [String: Any](), statusCode: 500, headers: nil)
        }
        waitForAsyncExpectations()
        let results = devices.map { device in
            verifySnapshot(matching: sut!,
                           as: .image(on: device.value),
                           named: "WithoutProducts-\(device.key)",
                           testName: "ProductListScreen")
        }
        results.forEach { XCTAssertNil($0) }
    }

    func test_snapshot_productListScreenWithProductsAndCart() {
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json") && isMethodGET()) { _ in
            let obj = ["products": [["code": "KEYCHAIN", "name": "Key Chain", "price": 5],
                                    ["code": "TSHIRT", "name": "T-Shirt", "price": 20],
                                    ["code": "MUG", "name": "Coffee Mug", "price": 7.5]]] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }
        tester().tapRow(at: IndexPath(item: 0, section: 0), inTableViewWithAccessibilityIdentifier: "ProductList")
        let results = devices.map { device in
            verifySnapshot(matching: sut!,
                           as: .image(on: device.value),
                           named: "WithProductsAndCart-\(device.key)",
                           testName: "ProductListScreen")
        }
        results.forEach { XCTAssertNil($0) }
    }
    
}
