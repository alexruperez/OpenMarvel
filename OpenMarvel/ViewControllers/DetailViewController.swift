import Domain
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet private weak var nameLabel: UILabel?
    var character: Character? {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    func configureView() {
        if let nameLabel = nameLabel {
            nameLabel.text = nil
        }
    }
}
