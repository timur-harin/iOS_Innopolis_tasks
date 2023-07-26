

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

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
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        let launchCount = UserDefaults.standard.integer(forKey: "launchCount")


        if launchedBefore && launchCount==2 {
            let message = "You open this app again. Thank you!"
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
