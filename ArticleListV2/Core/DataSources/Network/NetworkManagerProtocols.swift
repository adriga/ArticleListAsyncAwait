import Foundation

protocol ApiServiceManagerProtocol: AnyObject {
    func makeRequest<T: ApiService>(request: T) async -> ApiResponse<T>?
}
