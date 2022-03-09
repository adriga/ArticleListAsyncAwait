import Foundation

class InteractorDependencyContainer {
    private var coreComponentsFactory: CoreComponentsFactory
    
    init(coreComponentsFactory: CoreComponentsFactory) {
        self.coreComponentsFactory = coreComponentsFactory
    }
}

extension InteractorDependencyContainer: InteractorFactory {
    
    func productListInteractor() -> ProductListInteractor {
        return ProductListInteractor(networkManager: coreComponentsFactory.getNetworkManager())
    }
    
    func shoppingCartInteractor() -> ShoppingCartInteractor {
        return ShoppingCartInteractor()
    }
}
