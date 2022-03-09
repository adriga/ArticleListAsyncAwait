protocol ModuleFactory {
    func makeProductListModule(router: ProductListWireframeProtocol) -> ProductListViewController
}
