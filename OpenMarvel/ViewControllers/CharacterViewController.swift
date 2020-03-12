import Domain
import Kingfisher
import SafariServices
import UIKit

class CharacterViewController: UIViewController, CharacterView {
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var imageView: UIImageView?

    private var presenter: CharacterPresenter!
    var characterLoaded = false
    var character: Character? {
        get { presenter.character }
        set { presenter.character = newValue }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = CharacterPresenter(self)
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView?.kf.indicatorType = .activity
        presenter.viewLoaded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelThumbnailDownload()
    }

    // MARK: - View Model

    func set(state: CharacterViewState) {
        characterLoaded = false
        switch state {
        case let .character(character):
            configureView(character)
        case let .error(error):
            errorAlert(error)
        }
    }

    private func configureView(_ character: Character) {
        nameLabel?.text = character.name
        descriptionLabel?.text = character.description
        configureBarButtonItems(withLinks: !character.urls.isEmpty)
        cancelThumbnailDownload()
        imageView?.kf.setImage(with: character.thumbnailURL,
                               placeholder: UIImage(named: "OpenMarvel"))
        characterLoaded = true
    }

    private func configureBarButtonItems(withLinks: Bool) {
        var barButtonItems = [UIBarButtonItem]()
        barButtonItems.append(UIBarButtonItem(barButtonSystemItem: .action,
                                              target: self,
                                              action: #selector(share)))
        if withLinks {
            barButtonItems.append(UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                                  target: self,
                                                  action: #selector(showLinks)))
        }
        navigationItem.rightBarButtonItems = barButtonItems
    }

    private func cancelThumbnailDownload() {
        imageView?.kf.cancelDownloadTask()
    }

    // MARK: - Selectors

    @objc private func share(_ sender: UIBarButtonItem) {
        guard let character = character else { return }
        var activityItems: [Any] = [character.name, character.description]
        let cache = ImageCache.default
        if let thumbnailURL = character.thumbnailURL,
            cache.isCached(forKey: thumbnailURL.absoluteString) {
            cache.retrieveImage(forKey: thumbnailURL.absoluteString) { result in
                if case let .success(value) = result,
                    let image = value.image {
                    activityItems.append(image)
                }
                self.showActivityViewController(sender, activityItems: activityItems)
            }
        } else {
            showActivityViewController(sender, activityItems: activityItems)
        }
    }

    private func showActivityViewController(_ sender: UIBarButtonItem, activityItems: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: activityItems,
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        present(activityViewController, animated: true)
    }

    @objc private func showLinks(_ sender: UIBarButtonItem) {
        guard let character = character else { return }
        let urls = Set(character.urls.map { $1 })
        if urls.count == 1, let url = urls.first {
            showSafariViewController(url)
        } else {
            let alertController = UIAlertController(title: "Links",
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
            character.urls.filter { urls.contains($1) }.sorted {
                guard let lhs = $0.key as? String,
                    let rhs = $1.key as? String else {
                        return false
                }
                return lhs < rhs
            }.forEach { link, url in
                guard let link = link as? String else { return }
                alertController.addAction(UIAlertAction(title: link.localizedCapitalized,
                                                        style: .default,
                                                        handler: { _ in
                    self.showSafariViewController(url)
                }))
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.view.tintColor = navigationController?.navigationBar.tintColor
            alertController.popoverPresentationController?.barButtonItem = sender
            present(alertController, animated: true)
        }
    }

    private func showSafariViewController(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        let navigationBar = navigationController?.navigationBar
        safariViewController.preferredBarTintColor = navigationBar?.barTintColor
        safariViewController.preferredControlTintColor = navigationBar?.tintColor
        present(safariViewController, animated: true)
    }
}
