import Domain
import Injector

final class CharactersPresenter: Presenter {
    let shouldLoadMoreInLast = 3
    private weak var view: CharactersView?
    private let charactersUseCase: CharactersUseCase
    private var searching: String?
    private var offset: Int? {
        didSet { refresh() }
    }

    convenience init(_ view: CharactersView) {
        self.init(view, charactersUseCase: Injector.charactersUseCase)
    }

    private init(_ view: CharactersView, charactersUseCase: CharactersUseCase) {
        self.view = view
        self.charactersUseCase = charactersUseCase
    }

    func viewLoaded() {
        refresh()
    }

    func refresh() {
        characters(nameStartsWith: searching, offset: offset)
    }

    func search(_ searching: String?) {
        if let searching = searching, !searching.isEmpty {
            self.searching = searching
        } else {
            self.searching = nil
        }
        self.offset = nil
    }

    func loadMore(_ offset: Int) {
        if self.offset != offset {
            self.offset = offset
        }
    }

    private func characters(nameStartsWith: String?, offset: Int?) {
        charactersUseCase.characters(nameStartsWith: nameStartsWith,
                                     offset: offset,
                                     orderBy: .ascending) { result in
            switch result {
            case let .success(characters):
                if offset == nil {
                    self.view?.set(state: .set(characters))
                } else {
                    self.view?.set(state: .add(characters))
                }
            case let .failure(error):
                self.view?.set(state: .error(error.localizedDescription))
            }
        }
    }
}
