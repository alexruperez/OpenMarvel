import Domain
import Injector

final class CharactersPresenter: Presenter {
    private weak var view: CharactersView?
    private let charactersUseCase: CharactersUseCase

    convenience init(_ view: CharactersView) {
        self.init(view, charactersUseCase: Injector.charactersUseCase)
    }

    private init(_ view: CharactersView, charactersUseCase: CharactersUseCase) {
        self.view = view
        self.charactersUseCase = charactersUseCase
    }

    func viewLoaded() {
        characters()
    }

    private func characters(nameStartsWith: String? = nil) {
        charactersUseCase.characters(nameStartsWith: nameStartsWith,
                                     orderBy: .ascending) { result in
            switch result {
            case let .success(characters):
                self.view?.set(state: .characters(characters))
            case let .failure(error):
                self.view?.set(state: .error(error.localizedDescription))
            }
        }
    }
}
