package main

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

update_entity :: proc(entity: ^PhysicsEntity, movement: rl.Vector2, velocity: rl.Vector2) {
 frame_movement := rl.Vector2{movement.x + velocity.x, movement.y + velocity.y}

 entity.pos.x += frame_movement.x
 entity.pos.y += frame_movement.y
}

// render :: proc(entity: ^PhysicsEntity, surf) {
  
// }

// create_entity :: proc(game, e_type, pos, size) {
 
// }
