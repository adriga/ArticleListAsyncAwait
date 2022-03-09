import Foundation

struct ProductsDTO: Decodable {
    let products: [ProductDTO]
}

struct ProductDTO: Decodable {
    let code: String
    let name: String
    let price: Double
}
