import Domain
import Kingfisher
import UIKit

class CharactersViewController: UICollectionViewController, CharactersView {
    private var presenter: CharactersPresenter!
    private var characters = [Character]() {
        didSet {
            collectionView.refreshControl?.endRefreshing()
            collectionView.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = CharactersPresenter(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        presenter.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let splitViewController = splitViewController {
            clearsSelectionOnViewWillAppear = splitViewController.isCollapsed
        }
        super.viewWillAppear(animated)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < collectionView.adjustedContentInset.top {
            navigationItem.rightBarButtonItem = nil
        } else if navigationItem.rightBarButtonItem == nil {
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                target: self,
                                                action: #selector(switchSearch))
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }

    func set(state: CharactersViewState) {
        switch state {
        case let .set(characters):
            self.characters = characters
        case let .add(characters):
            self.characters.append(contentsOf: characters)
        case let .error(error):
            errorAlert(error)
        }
    }

    @objc func refresh() {
        presenter.refresh()
    }

    @objc func switchSearch() {
        navigationItem.searchController?.isActive.toggle()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharacter",
            let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let navigationController = segue.destination as? UINavigationController,
            let controller = navigationController.topViewController as? CharacterViewController {
            controller.character = characters[indexPath.item]
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Collection View

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = String(describing: CharacterCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? CharacterCell else {
            fatalError()
        }
        cell.configureCell(characters[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        (cell as? CharacterCell)?.configureLayer()
        if indexPath.item + presenter.shouldLoadMoreInLast > characters.count {
            presenter.loadMore(characters.count)
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        (cell as? CharacterCell)?.cancelThumbnailDownload()
    }
}

extension CharactersViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        ImagePrefetcher(urls: characters.compactMap { $0.thumbnailURL }).start()
    }
}

extension CharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.search(searchController.searchBar.text)
    }
}
