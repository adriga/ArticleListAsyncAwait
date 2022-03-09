@testable import ArticleListV2

class NetworkManagerMock: ApiServiceManagerProtocol {
    
    var returnError = false
    var responseDto: Decodable = ProductsDTO(products: [ProductDTO(code: "KEYCHAIN", name: "Key Chain", price: 5), ProductDTO(code: "TSHIRT", name: "T-Shirt", price: 20)])
    var responseError: ApiError = .badResponse
    
    func makeRequest<T: ApiService>(request: T) async -> ApiResponse<T>? {
        if returnError {
            return .failed(responseError)
        }
        return .succeed(responseDto as! T.Response)
    }
}
