

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let launchViewController = LaunchViewController()
        let mainViewController = CharacterListViewController()

        window = UIWindow(windowScene: windowScene)

        window?.rootViewController = launchViewController
        window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.window?.rootViewController = mainViewController
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
