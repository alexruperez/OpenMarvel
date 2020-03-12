import Domain

enum CharactersViewState: ViewState {
    case set([Character])
    case add([Character])
    case error(String)
}

protocol CharactersView: ViewModel {
    func set(state: CharactersViewState)
}
