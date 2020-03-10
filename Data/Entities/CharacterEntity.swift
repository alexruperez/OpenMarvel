import Domain

struct CharacterEntity: Entity {
    func toDomain() -> Character { Character() }
}
