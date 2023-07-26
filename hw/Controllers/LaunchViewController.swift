import UIKit

class LaunchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let launchView = LaunchView(frame: view.bounds)
        view.addSubview(launchView)
    }
}
