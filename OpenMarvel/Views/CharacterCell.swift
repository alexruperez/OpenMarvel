import Domain
import Kingfisher
import UIKit

class CharacterCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var imageView: UIImageView?

    func configureCell(_ character: Character) {
        nameLabel?.text = character.name
        cancelThumbnailDownload()
        imageView?.kf.indicatorType = .activity
        imageView?.kf.setImage(with: character.thumbnailURL,
                               placeholder: UIImage(named: "OpenMarvel"))
    }

    func configureLayer() {
        contentView.layer.cornerRadius = 2
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor(named: "ThumbnailColor")?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect:bounds,
                                        cornerRadius:contentView.layer.cornerRadius).cgPath
    }

    func cancelThumbnailDownload() {
        imageView?.kf.cancelDownloadTask()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureLayer()
    }
}
