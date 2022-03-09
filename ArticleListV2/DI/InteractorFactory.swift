protocol InteractorFactory {
    func productListInteractor() -> ProductListInteractor
    func shoppingCartInteractor() -> ShoppingCartInteractor
}
