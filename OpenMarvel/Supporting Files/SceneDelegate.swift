import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let window = window,
            let splitViewController = window.rootViewController as? UISplitViewController,
            let lastViewController = splitViewController.viewControllers.last,
            let navigationController = lastViewController as? UINavigationController,
            let navigationItem = navigationController.topViewController?.navigationItem
            else { return }
        navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        splitViewController.maximumPrimaryColumnWidth = 315
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = self
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if let navigationController = secondaryViewController as? UINavigationController,
            let topViewController = navigationController.topViewController,
            let characterViewController = topViewController as? CharacterViewController,
            !characterViewController.characterLoaded {
            return true
        }
        return false
    }
}
