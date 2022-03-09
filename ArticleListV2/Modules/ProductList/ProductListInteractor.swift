import Foundation

protocol ProductListInteractorInputProtocol {
    
    /* Presenter -> Interactor */
    func getAllProducts()
}

protocol ProductListInteractorOutputProtocol: AnyObject {
    
    /* Interactor -> Presenter */
    func productsDidLoad(products: [ProductEntity])
    func getProductsError()
}

class ProductListInteractor: AsyncInteractor {
    
    weak var presenter: ProductListInteractorOutputProtocol?
    var networkManager: ApiServiceManagerProtocol
    
    init(networkManager: ApiServiceManagerProtocol) {
        self.networkManager = networkManager
    }
    
}

extension ProductListInteractor: ProductListInteractorInputProtocol {
    
    func getAllProducts() {
        executeAsyncTaskInBackground {
            await self.networkManager.makeRequest(request: GetProductsApiService())
        } completionInMainThread: { response in
            switch response {
            case .failed:
                self.presenter?.getProductsError()
            case .succeed(let productsDto):
                self.presenter?.productsDidLoad(products: productsDto.products.map({ ProductEntity(dto: $0) }))
            default:
                self.presenter?.getProductsError()
            }
        }
    }
}
