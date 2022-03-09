import Foundation

class PresenterDependencyContainer {
    private lazy var interactorFactory: InteractorFactory = InteractorDependencyContainer(coreComponentsFactory: coreComponentsFactory)
    private var coreComponentsFactory: CoreComponentsFactory
    
    init(coreComponentsFactory: CoreComponentsFactory) {
        self.coreComponentsFactory = coreComponentsFactory
    }
}

extension PresenterDependencyContainer: PresenterFactory {
    
    func productListPresenter(view: ProductListViewProtocol, router: ProductListWireframeProtocol) -> ProductListPresenter {
        let productListInteractor = interactorFactory.productListInteractor()
        let shoppingCartInteractor = interactorFactory.shoppingCartInteractor()
        let presenter = ProductListPresenter()
        presenter.view = view
        presenter.productListInteractor = productListInteractor
        presenter.shoppingCartInteractor = shoppingCartInteractor
        presenter.router = router
        productListInteractor.presenter = presenter
        shoppingCartInteractor.presenter = presenter
        return presenter
    }
    
}
