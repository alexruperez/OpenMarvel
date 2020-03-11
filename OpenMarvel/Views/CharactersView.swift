import Domain

enum CharactersViewState: ViewState {
    case characters([Character])
    case error(String)
}

protocol CharactersView: ViewModel {
    func set(state: CharactersViewState)
}
