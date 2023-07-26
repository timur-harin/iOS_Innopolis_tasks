import UIKit

class LaunchView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.backgroundColor = .white
        let speedRunGif = UIImage.gifImageWithName("speedrun")
        let imageView = UIImageView(image: speedRunGif)
        imageView.frame = CGRect(x: 0.0, y: self.frame.size.height / 2 - 100, width: self.frame.size.width, height: 200.0)
        self.addSubview(imageView)
    }
}
