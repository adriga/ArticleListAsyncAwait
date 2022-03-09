import Foundation

struct GetProductsApiService: ApiService {
    
    typealias Response = ProductsDTO
    
    var resourceName: String {
        return "/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json"
    }
    
    var operationType: String {
        return "GET"
    }
    
    var body: [String: Any]? {
        return nil
    }
}
