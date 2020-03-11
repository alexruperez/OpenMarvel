import Domain

enum CharacterViewState: ViewState {
    case character(Character)
    case error(String)
}

protocol CharacterView: ViewModel {
    func set(state: CharacterViewState)
}
