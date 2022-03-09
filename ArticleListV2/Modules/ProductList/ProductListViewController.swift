import UIKit

class ProductListViewController: UIViewController {

    var presenter: ProductListPresenterProtocol?
    var products: [ProductViewEntity]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noProductsView: UIView!
    @IBOutlet weak var noProductsLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartProductsLabel: UILabel!
    @IBOutlet weak var cartAmountLabel: UILabel!
    @IBOutlet weak var tableViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var cartViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

// Actions
extension ProductListViewController {
    
    @IBAction func tryAgainButtonClicked(_ sender: Any) {
        presenter?.reloadProducts()
    }
    
    @IBAction func shoppingCartClicked(gesture: UITapGestureRecognizer) {
        presenter?.shoppingCartClicked()
    }
}

extension ProductListViewController: ProductListViewProtocol {
    
    func configureView() {
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        tableView.accessibilityIdentifier = "ProductList"
        
        noProductsLabel.font = UIFont.regularFont(ofSize: 20)
        noProductsLabel.textColor = .black
        noProductsLabel.text = "no_products".localizedString
        noProductsLabel.accessibilityIdentifier = "no_products".localizedString
        
        tryAgainButton.titleLabel?.font = UIFont.regularFont(ofSize: 15)
        tryAgainButton.setTitle("try_again_button".localizedString, for: .normal)
        
        cartProductsLabel.font = UIFont.boldFont(ofSize: 15)
        cartProductsLabel.textColor = .black
        cartProductsLabel.accessibilityIdentifier = "cartProductsLabel"
        cartAmountLabel.font = UIFont.boldFont(ofSize: 18)
        cartAmountLabel.textColor = .black
        
        cartView.layer.shadowColor = UIColor.black.cgColor
        cartView.layer.shadowOpacity = 0.5
        cartView.layer.shadowOffset = CGSize.zero
        cartView.layer.shadowRadius = 1
        cartView.layer.shadowPath = UIBezierPath(rect: UIScreen.main.bounds).cgPath
        cartView.layer.shouldRasterize = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shoppingCartClicked(gesture:)))
        cartView.addGestureRecognizer(tapGesture)
    }
    
    func reloadProducts(products: [ProductViewEntity]) {
        self.products = products
        noProductsView.isHidden = true
        tableView.isHidden = false
        cartView.isHidden = false
        tableView.reloadData()
    }
    
    func showNotProductsView() {
        noProductsView.isHidden = false
        tableView.isHidden = true
        cartView.isHidden = true
    }
    
    func showCartView() {
        if tableViewBottomMargin.constant == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.tableViewBottomMargin.constant = self.cartViewHeight.constant
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func hideCartView() {
        if tableViewBottomMargin.constant == cartViewHeight.constant {
            UIView.animate(withDuration: 0.5, animations: {
                self.tableViewBottomMargin.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setCartProductsCount(_ cartCount: Int) {
        cartProductsLabel.text = String(format: "shopping_cart_products".localizedString, cartCount)
    }
    
    func setCartAmount(_ cartAmount: Double) {
        cartAmountLabel.text = String(format: "shopping_cart_total".localizedString, cartAmount)
    }
}

extension ProductListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell, let products = products {
            cell.configureProductCell(product: products[indexPath.row])
            cell.accessibilityIdentifier = "ProductCell"
            return cell
        }
        return UITableViewCell()
    }
}

extension ProductListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let products = products {
            presenter?.didSelectProduct(product: ProductEntity(viewEntity: products[indexPath.row]))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
