package entities

import rl "vendor:raylib"

EntityType :: struct {
 name: string,
}

PhysicsEntity :: struct {
 gameState: GameState,
 e_type: EntityType,
 pos: rl.Vector2,
 size: rl.Vector2,
}

update_entity :: proc(entity: ^PhysicsEntity, movement: rl.Vector2) {
 
}

create_entity :: proc(game, e_type, pos, size) {
 
}
