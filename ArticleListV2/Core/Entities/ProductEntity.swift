import Foundation

struct ProductEntity {
    
    let code: String
    let name: String
    let price: String
    
    init(code: String, name: String, price: String) {
        self.code = code
        self.name = name
        self.price = price
    }
    
    init(dto: ProductDTO) {
        code = dto.code
        name = dto.name
        price = "\(dto.price)"
    }
    
    init(viewEntity: ProductViewEntity) {
        code = viewEntity.code
        name = viewEntity.name
        price = viewEntity.price
    }
}
