package main

import rl "vendor:raylib"

PhysicsEntity :: struct {
 e_type: string,
 pos: rl.Vector2,
 size: rl.Vector2,
 velocity: rl.Vector2,

 collisions: map[string]bool,
}

new_entity :: proc(type: string, pos: rl.Vector2, size: rl.Vector2) -> PhysicsEntity {
 return PhysicsEntity {
  e_type=type,
  pos=pos,
  size=size,
  velocity=rl.Vector2{0,0},
  collisions= {"up"=false, "down"=false, "right"=false, "left"=false},
 }
}

rect :: proc(entity: ^PhysicsEntity) -> rl.Rectangle {
 return rl.Rectangle{entity.pos.x, entity.pos.y,entity.size.x, entity.size.y}
}

update_entity :: proc(entity: ^PhysicsEntity, movement: rl.Vector2) {
 entity.collisions = {"up"=false,"down"=false,"right"=false,"left"=false}

 frame_movement := rl.Vector2{movement.x + entity.velocity.x, movement.y + entity.velocity.y}

 entity.pos.x += frame_movement.x
 entity_rect : rl.Rectangle = rect(entity)

 


 entity.pos.y += frame_movement.y

 
}

// render :: proc(entity: ^PhysicsEntity, surf) {
  
// }

// create_entity :: proc(game, e_type, pos, size) {
 
// }
