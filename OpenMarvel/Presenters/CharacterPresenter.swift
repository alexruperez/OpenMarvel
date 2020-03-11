import Domain
import Injector

final class CharacterPresenter: Presenter {
    private weak var view: CharacterView?
    var character: Character? {
        didSet {
            if let character = character {
                self.character(character.id)
            }
        }
    }
    private let charactersUseCase: CharactersUseCase

    convenience init(_ view: CharacterView) {
        self.init(view, charactersUseCase: Injector.charactersUseCase)
    }

    private init(_ view: CharacterView, charactersUseCase: CharactersUseCase) {
        self.view = view
        self.charactersUseCase = charactersUseCase
    }

    func viewLoaded() {
        if let character = character {
            view?.set(state: .character(character))
        }
    }

    private func character(_ id: Int) {
        charactersUseCase.character(id) { result in
            switch result {
            case let .success(character):
                self.view?.set(state: .character(character))
            case let .failure(error):
                self.view?.set(state: .error(error.localizedDescription))
            }
        }
    }
}
