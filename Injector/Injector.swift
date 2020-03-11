import Data
import Domain

public final class Injector {
    public static var charactersUseCase: CharactersUseCase {
        CharactersUseCase(CharactersProvider())
    }
}
