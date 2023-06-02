//
//  SceneDelegate.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var navigationController = UINavigationController()
    private lazy var coreDataStore = configureCoreDataStore()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        
        let itemListViewController = makeItemListViewController()
        navigationController.setViewControllers([itemListViewController], animated: false)
        configureCartNavigationItem(for: itemListViewController)
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

private extension SceneDelegate {
    func makeItemListViewController() -> ItemListViewController {
        let itemLoader: ItemLoader = StubbedDataItemLoader()
        let mainThreadItemLoader = MainThreadDispatchDecorator(decoratee: itemLoader)
        let itemListVC = ItemListUIComposer.composedItemList(with: mainThreadItemLoader, select: { [weak self] selectedItem in
            guard let self = self else { return }
            
            let itemDetailVC = self.makeItemDetailController(with: selectedItem)
            self.navigationController.pushViewController(itemDetailVC, animated: true)
        })
        itemListVC.title = "商品列表"
        return itemListVC
    }
    
    func makeItemDetailController(with selectedItem: Item) -> ItemDetailViewController {
        let localItemSaver: CartItemSaver = LocalCartItemSaver(storeSaver: coreDataStore ?? NullStore())
        let mainThreadLocalItemSaver = MainThreadDispatchDecorator(decoratee: localItemSaver)
        let itemDetailVC = ItemListUIComposer.composedItemDetail(with: selectedItem, itemSaver: mainThreadLocalItemSaver)
        itemDetailVC.title = "商品詳情"
        return itemDetailVC
    }
    
    func makeCartViewController() -> CartViewController {
        let cartLoader: CartItemsLoader = LocalCartItemsLoader(storeLoader: coreDataStore ?? NullStore())
        let mainThreadCartLoader = MainThreadDispatchDecorator(decoratee: cartLoader)
        let cartVC = ItemListUIComposer.composedCart(with: mainThreadCartLoader, checkout: { [weak self] items in
            guard let self = self else { return }
            
            let checkoutVC = self.makeCheckoutViewController(with: items)
            self.navigationController.pushViewController(checkoutVC, animated: true)
        })
        cartVC.title = "購物車"
        return cartVC
    }
    
    func makeCheckoutViewController(with items: [Item]) -> CheckoutViewController {
        let orderSaver: OrderSaver = LocalOrderSaver(storeSaver: coreDataStore ?? NullStore())
        let mainThreadOrderSaver = MainThreadDispatchDecorator(decoratee: orderSaver)
        let checkoutVC = OrderUIComposer.composedCheckout(with: items, orderSaver: mainThreadOrderSaver)
        checkoutVC.title = "確認訂單"
        return checkoutVC
    }
    
    func configureCartNavigationItem(for controller: UIViewController) {
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "購物車",
            style: .done,
            target: self,
            action: #selector(goToCart))
    }
    
    @objc private func goToCart() {
        let cartVC = makeCartViewController()
        navigationController.pushViewController(cartVC, animated: true)
    }
    
    private func configureCoreDataStore() -> CoreDataStore? {
        let coreDataStore = try? CoreDataStore(storeURL: NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("JKOStore.sqlite"))
        return coreDataStore
    }
}
