import UIKit


extension UIImageView {
    func saveImage(name: String, image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent(name)!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        
        return nil
    }
    
    func download(from url: NSURL, mode: ContentMode = .scaleAspectFit) {
        let filename = url.relativePath?.split(separator: "/").last
        contentMode = mode
        
        if let filename, let cachedImage = getSavedImage(named: String(filename)) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        URLSession.shared.dataTask(with: url as URL) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType,
                  mimeType.hasPrefix("image"),
                  let data = data,
                  let image = UIImage(data: data)
            else { return }
            if let filename {
                DispatchQueue.main.async { [weak self] in
                    self?.saveImage(name: String(filename), image: image)
                    self?.image = image
                }
            }
        }.resume()
    }
    
    func download(from link: String, contentMode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        download(from: url as NSURL, mode: contentMode)
    }
}
