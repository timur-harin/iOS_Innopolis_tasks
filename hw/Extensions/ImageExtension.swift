import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func load(url: URL, mode: ContentMode, tableView: UITableView, indexPath: IndexPath,  completion: (() -> Void)? = nil) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
           self.image = cachedImage
           self.contentMode = mode
           completion?()
           tableView.reloadRows(at: [indexPath], with: .none) // Reload table data
           return
       }

       // If not in cache, download the image
       URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
           guard let data = data, let downloadedImage = UIImage(data: data) else { return }

           // Store the downloaded image in cache
           imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)

           DispatchQueue.main.async {
               self?.image = downloadedImage
               self?.contentMode = mode
               completion?() // Call completion handler if provided
               tableView.reloadRows(at: [indexPath], with: .none) // Reload table data
           }
       }.resume()
   }

    func download(link: String, contentMode: ContentMode = .scaleAspectFit, tableView: UITableView, indexPath: IndexPath) {
        guard let url = URL(string: link) else { return }
        self.load(url: url, mode: contentMode, tableView: tableView, indexPath: indexPath)
    }
}
