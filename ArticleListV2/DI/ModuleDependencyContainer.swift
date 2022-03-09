import Foundation

class ModuleDependencyContainer {
    private lazy var presenterFactory: PresenterFactory = PresenterDependencyContainer(coreComponentsFactory: coreComponentsFactory)
    private lazy var coreComponentsFactory: CoreComponentsFactory = CoreComponentsDependencyContainer()
}

extension ModuleDependencyContainer: ModuleFactory {
    
    func makeProductListModule(router: ProductListWireframeProtocol) -> ProductListViewController {
        let view = ProductListViewController(nibName: nil, bundle: nil)
        view.presenter = presenterFactory.productListPresenter(view: view, router: router)
        return view
    }
}
