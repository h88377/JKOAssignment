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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        navigationController.setViewControllers([makeItemListViewController()], animated: false)
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

private extension SceneDelegate {
    func makeItemListViewController() -> ItemListViewController {
        let itemLoader = StubbedDataItemLoader()
        let itemListVC = ItemListUIComposer.composedItemList(with: itemLoader, select: { [weak self] selectedItem in
            guard let self = self else { return }
            
            let localItemSaver = LocalCartItemSaver(storeSaver: self.configureCoreDataStore() ?? NullStoreSaver())
            let itemDetailVC = ItemListUIComposer.composedItemDetail(with: selectedItem, itemSaver: localItemSaver)
            self.navigationController.pushViewController(itemDetailVC, animated: true)
        })
        return itemListVC
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
