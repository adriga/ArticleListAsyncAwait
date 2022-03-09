import Foundation
@testable import ArticleListV2

struct TestGetApiService: ApiService {
    
    typealias Response = TestResponseDTO
    
    var resourceName: String {
        return "/test"
    }
    
    var operationType: String {
        return "GET"
    }
    
    var body: [String: Any]? {
        return nil
    }
}
