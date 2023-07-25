
import UIKit

class LaunchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let speedRunGif = UIImage.gifImageWithName("speedrun")
        let imageView = UIImageView(image: speedRunGif)
        imageView.frame = CGRect(x: 0.0, y: self.view.frame.size.height / 2 - 100, width: self.view.frame.size.width, height: 200.0)

        view.addSubview(imageView)
    }
}
