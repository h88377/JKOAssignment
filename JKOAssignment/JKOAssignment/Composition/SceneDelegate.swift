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
        configureCartNavigationItem(for: itemListVC)
        return itemListVC
    }
    
    func makeItemDetailController(with selectedItem: Item) -> ItemDetailViewController {
        let localItemSaver: CartItemSaver = LocalCartItemSaver(storeSaver: coreDataStore ?? NullStore())
        let mainThreadLocalItemSaver = MainThreadDispatchDecorator(decoratee: localItemSaver)
        let itemDetailVC = ItemListUIComposer.composedItemDetail(with: selectedItem, itemSaver: mainThreadLocalItemSaver, checkout: { [weak self] item in
            guard let self = self else { return }
            
            let checkoutVC = self.makeCheckoutViewController(with: [OrderItem(name: item.name, description: item.description, price: item.price, timestamp: item.timestamp, imageName: item.imageName)])
            self.navigationController.pushViewController(checkoutVC, animated: true)
        })
        itemDetailVC.title = "商品詳情"
        return itemDetailVC
    }
    
    func makeCartViewController() -> CartViewController {
        let cartLoader: CartItemsLoader = LocalCartItemsLoader(storeLoader: coreDataStore ?? NullStore())
        let mainThreadCartLoader = MainThreadDispatchDecorator(decoratee: cartLoader)
        let cartDeleter: CartItemDeleter = LocalCartItemDeleter(storeDeleter: coreDataStore ?? NullStore())
        let mainThreadCartDeleter = MainThreadDispatchDecorator(decoratee: cartDeleter)
        let cartVC = ItemListUIComposer.composedCart(with: mainThreadCartLoader, cartDeleter: mainThreadCartDeleter, checkout: { [weak self] items in
            guard let self = self else { return }
            
            let checkoutVC = self.makeCheckoutViewController(with: items.map { OrderItem(name: $0.name, description: $0.description, price: $0.price, timestamp: $0.timestamp, imageName: $0.imageName)} )
            self.navigationController.pushViewController(checkoutVC, animated: true)
        })
        cartVC.title = "購物車"
        return cartVC
    }
    
    func makeCheckoutViewController(with items: [OrderItem]) -> CheckoutViewController {
        let orderSaver = LocalOrderSaver(storeSaver: coreDataStore ?? NullStore())
        let orderSaverWithCartDeleter: OrderSaver = OrderSaverWithCartDeleterDecorator(decoratee: orderSaver, cartDeleter: coreDataStore ?? NullStore())
        let mainThreadOrderSaver = MainThreadDispatchDecorator(decoratee: orderSaverWithCartDeleter)
        let checkoutVC = OrderUIComposer.composedCheckout(with: items, orderSaver: mainThreadOrderSaver, finish: { [weak self] message in
            self?.navigationController.popToRootViewController(animated: true)
            
            if let rootVC = self?.navigationController.topViewController as? ItemListViewController {
                rootVC.fadingView.show(message, on: rootVC.view)
            }
        })
        checkoutVC.title = "確認訂單"
        return checkoutVC
    }
    
    func makeOrderHistoryViewController() -> OrderHistoryViewController {
        let orderLoader: OrderLoader = LocalOrderLoader(storeLoader: coreDataStore ?? NullStore())
        let mainThreadOrderLoader = MainThreadDispatchDecorator(decoratee: orderLoader)
        return OrderUIComposer.composedOrderHistory(with: mainThreadOrderLoader)
    }
    
    private func configureCartNavigationItem(for controller: UIViewController) {
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
