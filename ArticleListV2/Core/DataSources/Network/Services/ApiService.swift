import Foundation

protocol ApiService {
    
    associatedtype Response: Decodable
    var resourceName: String { get }
    var operationType: String { get }
    var body: [String: Any]? { get }
}
