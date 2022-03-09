import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import ArticleListV2

class NetworkManagerTests: XCTestCase {

    var sut: NetworkManager!
    
    override func setUp() {
        super.setUp()
        self.sut = NetworkManager()
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func test_GETRequest_with200OkResponse_shouldResponseOk() async {
        // Given
        // Mock GET request OK
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/test") && isMethodGET()) { _ in
            let obj = ["data1": "data1",
                       "data2": "data2"] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }
        
        // When
        let response = await sut.makeRequest(request: TestGetApiService())
        
        // Then
        switch response {
        case .succeed(let reponseObject):
            XCTAssertNotNil(reponseObject)
        default:
            XCTFail()
        }
    }
    
    func test_GETRequest_with500ErrorResponse_shouldResponseBadResponseError() async {
        // Given
        // Mock GET request KO with 500 error
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/test") && isMethodGET()) { _ in
            return HTTPStubsResponse(jsonObject: [String: Any](), statusCode: 500, headers: nil)
        }
        
        // When
        let response = await sut.makeRequest(request: TestGetApiService())
        
        // Then
        switch response {
        case .failed(let error):
            XCTAssertEqual(error, ApiError.badResponse)
        default:
            XCTFail()
        }
    }
    
    func test_GETRequest_withBadBody_shouldResponseDecodeError() async {
        // Given
        // Mock GET request OK
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/test") && isMethodGET()) { _ in
            let obj = ["data1": "data1"] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }

        // When
        let response = await sut.makeRequest(request: TestGetApiService())

        // Then
        switch response {
        case .failed(let error):
            XCTAssertEqual(error, ApiError.decodeError)
        default:
            XCTFail()
        }
    }

}
