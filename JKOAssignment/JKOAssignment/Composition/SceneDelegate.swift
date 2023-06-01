//
//  SceneDelegate.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/5/31.
//

import UIKit

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
        let itemListVC = ItemListUIComposer.composedItemList(with: itemLoader) { [weak self] selectedItem in
            let itemDetailVC = ItemListUIComposer.composedItemDetail(with: selectedItem, itemSaver: NullItemSaver())
            self?.navigationController.pushViewController(itemDetailVC, animated: true)
        }
        return itemListVC
    }
}

final class NullItemSaver: ItemSaver {
    func save(item: Item, completion: @escaping (ItemSaver.Result) -> Void) {
        return
    }
}
