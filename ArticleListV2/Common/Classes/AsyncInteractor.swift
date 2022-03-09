import Foundation

class AsyncInteractor {
    
    func executeAsyncTaskInBackground<T>(backgroundTask: (() async -> (T))? = nil, completionInMainThread completion: ((T?) -> Void)? = nil) {
        Task {
            let result = await backgroundTask?()
            if let completion = completion {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func executeInBackground<T>(backgroundTask: (() -> T)? = nil, completionInMainThread completion: ((T?) -> Void)? = nil) {
        Task {
            let result = backgroundTask?()
            if let completion = completion {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}
