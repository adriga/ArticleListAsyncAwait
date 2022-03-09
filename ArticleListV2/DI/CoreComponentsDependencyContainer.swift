import Foundation

class CoreComponentsDependencyContainer {
    private lazy var networkManager = NetworkManager()
}

extension CoreComponentsDependencyContainer: CoreComponentsFactory {
    
    func getNetworkManager() -> NetworkManager {
        return networkManager
    }
}
