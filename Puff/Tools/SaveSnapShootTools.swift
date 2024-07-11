//

import UIKit
import Photos

extension UIView {
    func toImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
    }
}

extension UIImage {
    func saveToPhotosAlbum(completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                let error = NSError(domain: "SaveToPhotosAlbum", code: 1, userInfo: [NSLocalizedDescriptionKey: "please go to the settings page to open the album permissions first"])
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: self)
                creationRequest.creationDate = Date()
            }) { success, error in
                DispatchQueue.main.async {
                    completion(success, error)
                }
            }
        }
    }
}
