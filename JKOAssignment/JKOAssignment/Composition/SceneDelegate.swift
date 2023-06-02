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
            
            let localItemSaver: CartItemSaver = LocalCartItemSaver(storeSaver: self.coreDataStore ?? NullStoreSaver())
            let mainThreadLocalItemSaver = MainThreadDispatchDecorator(decoratee: localItemSaver)
            let itemDetailVC = ItemListUIComposer.composedItemDetail(with: selectedItem, itemSaver: mainThreadLocalItemSaver)
            self.navigationController.pushViewController(itemDetailVC, animated: true)
        })
        return itemListVC
    }
    
    func makeCartViewController() -> CartViewController {
        let cartLoader: CartItemsLoader = LocalCartItemsLoader(storeLoader: coreDataStore ?? NullStoreLoader())
        let mainThreadCartLoader = MainThreadDispatchDecorator(decoratee: cartLoader)
        return ItemListUIComposer.composedCart(with: mainThreadCartLoader)
    }
    
    func configureCartNavigationItem(for controller: UIViewController) {
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "購物車",
            style: .done,
            target: self,
            action: #selector(goToCart))
    }
    
    @objc private func goToCart() {
        navigationController.pushViewController(makeCartViewController(), animated: true)
    }
    
    private func configureCoreDataStore() -> CoreDataStore? {
        let coreDataStore = try? CoreDataStore(storeURL: NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("JKOStore.sqlite"))
        return coreDataStore
    }
}

private final class NullStoreSaver: CartItemStoreSaver {
    func insert(_ item: Item, completion: @escaping (CartItemStoreSaver.Result) -> Void) {
        return
    }
}

private final class NullStoreLoader: CartItemsStoreLoader {
    func retrieve(completion: @escaping (CartItemsStoreLoader.Result) -> Void) {
        return
    }
}
