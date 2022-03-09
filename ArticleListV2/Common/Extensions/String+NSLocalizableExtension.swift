import Foundation

extension String {
    public var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
}
