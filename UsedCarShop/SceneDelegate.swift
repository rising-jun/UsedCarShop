//
//  SceneDelegate.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/28.
//

import UIKit
import NMapsMap

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.makeKeyAndVisible()
        window.rootViewController = SplashViewController()
        NMFAuthManager.shared().clientId = NaverMap.clientID
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let arroundShopMapViewController = ArroundShopMapViewController()
            let reactor = ArroundShopMapReactor()
            arroundShopMapViewController.reactor = reactor
            window.rootViewController = UINavigationController(rootViewController: arroundShopMapViewController)
        }
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

enum NaverMap {
    static let clientID: String = "d4h1sjy86s"
}
