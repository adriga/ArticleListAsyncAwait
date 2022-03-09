import Foundation
@testable import ArticleListV2

struct GetApiServiceMock: ApiService {
    
    typealias Response = ResponseDTOMock
    
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
