import Foundation

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
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        // Get server certificate
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
              let serverCertificate = serverCertificates.first else {
                  completionHandler(.cancelAuthenticationChallenge, nil)
                  return
        }

        // Evaluate server certificate
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)

        // Local and server certificates data
        let serverCertificateData = getCertificateData(serverCertificate)
        guard let pathToCertificate = Bundle.main.path(forResource: "www.github.com", ofType: "cer"),
              let localCertificateData = NSData(contentsOfFile: pathToCertificate) else {
                  completionHandler(.cancelAuthenticationChallenge, nil)
                  return
        }

        // Compare certificates
        if isServerTrusted && serverCertificateData == (localCertificateData as Data) {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
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
    
    func getCertificateData(_ certificate: SecCertificate) -> Data {
        let serverCertificateCFData = SecCertificateCopyData(certificate)
        let data = CFDataGetBytePtr(serverCertificateCFData)
        let size = CFDataGetLength(serverCertificateCFData)
        let serverCertificateData = NSData(bytes: data, length: size)
        return serverCertificateData as Data
    }
}
