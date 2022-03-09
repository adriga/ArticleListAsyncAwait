protocol PresenterFactory {
    func productListPresenter(view: ProductListViewProtocol, router: ProductListWireframeProtocol) -> ProductListPresenter
}
