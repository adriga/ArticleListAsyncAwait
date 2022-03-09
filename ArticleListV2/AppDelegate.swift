import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var moduleFactory: ModuleFactory = ModuleDependencyContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        launchInitialScreen()
        return true
    }
}

private extension AppDelegate {

    func launchInitialScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let initialScreen = ProductListRouter().createModule(factory: moduleFactory) {
            window?.rootViewController = UINavigationController(rootViewController: initialScreen)
            window?.makeKeyAndVisible()
            configureAppGeneralAppearence()
        }
    }
    
    func configureAppGeneralAppearence() {
        UINavigationBar.appearance().barTintColor = .secondaryColor
        UINavigationBar.appearance().tintColor = .secondaryColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryColor ?? .white]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .highlighted)
        UINavigationBar.appearance().isTranslucent = false
    }
}

