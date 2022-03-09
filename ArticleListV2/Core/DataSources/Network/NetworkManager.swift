import Foundation
import CommonCrypto

enum ApiResponse<T: ApiService> {
    case succeed(T.Response)
    case failed(ApiError)
}

class NetworkManager: NSObject, ApiServiceManagerProtocol {
 
    final let serverBaseUrl = "https://gist.githubusercontent.com/adriga"
    
    func makeRequest<T: ApiService>(request: T) async -> ApiResponse<T>? {
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let request = RequestHelper.getUrlRequest(url: serverBaseUrl + request.resourceName, body: request.body, operationType: request.operationType)
        guard let request = request else { return nil }
        return await requestWithJSONResponse(urlSession, request: request)
    }
}

extension NetworkManager: URLSessionDelegate {
    
    static let publicKeyHash = "xlDAST56PmiT3SR0WdFOR3dghwJrQ8yXx6JLSqTIRpk="
    private static let rsa2048Asn1Header:[UInt8] = [0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00];

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
              let serverCertificate = serverCertificates.first,
              let serverPublicKey = SecCertificateCopyKey(serverCertificate),
              let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) else {
                  completionHandler(.cancelAuthenticationChallenge, nil)
                  return
              }

        // Server Hash key
        let serverHashKey = sha256(data: serverPublicKeyData as Data)
        // Local Hash Key
        let publickKeyLocal = type(of: self).publicKeyHash

        if serverHashKey != publickKeyLocal {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
        else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

private extension NetworkManager {
    
    func requestWithJSONResponse<T: ApiService>(_ urlSession: URLSession, request: URLRequest) async -> ApiResponse<T> {
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return .failed(.badResponse)
            }
            let dto = try JSONDecoder().decode(T.Response.self, from: data)
            return .succeed(dto)
        } catch {
            return .failed(.decodeError)
        }
    }
    
    func sha256(data: Data) -> String {
        var keyWithHeader = Data(NetworkManager.rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        keyWithHeader.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
}
