package main

import rl "vendor:raylib"
import "core:strings"
import "core:strconv"

PhysicsEntity :: struct {
 e_type: string,
 pos: rl.Vector2,
 size: rl.Vector2,
 velocity: rl.Vector2,
 action: string,
 anim_offset: [dynamic]int,
 flip: bool,
 animation: Animation,

 air_time: u8,
 
 collisions: map[string]bool,
}

new_entity :: proc(type: string, pos: rl.Vector2, size: rl.Vector2, action: string) -> PhysicsEntity {
// new_entity :: proc(type: string, pos: rl.Vector2, size: rl.Vector2) -> PhysicsEntity {
 return PhysicsEntity {
  e_type=type,
  pos=pos,
  size=size,
  velocity=rl.Vector2{0,0},
  collisions= {"up"=false, "down"=false, "right"=false, "left"=false},
  action="idle",
  air_time=0,
 }
}

set_action :: proc(entity: ^PhysicsEntity, action: string, assets: ^Assets) {
 if action != entity.action {
  entity.action = action
  entity.animation = create_animation(assets.assets[strings.concatenate({entity.e_type, "/", entity.action})])
 }
}

rect :: proc(entity: ^PhysicsEntity) -> rl.Rectangle {
 return rl.Rectangle{entity.pos.x, entity.pos.y,entity.size.x, entity.size.y}
}

update_entity :: proc(gameState: ^GameState, entity: ^PhysicsEntity, movement: rl.Vector2, assets: ^Assets) {
 entity.collisions = {"up"=false,"down"=false,"right"=false,"left"=false}

 frame_movement := rl.Vector2{movement.x + entity.velocity.x, movement.y + entity.velocity.y}

 entity.pos.x += frame_movement.x
 entity_rect : rl.Rectangle = rect(entity)

 for rect in physics_rects_around(&gameState.tilemap, entity.pos) {
  if rl.CheckCollisionRecs(entity_rect, rect) {
   if frame_movement.x > 0 {
    entity_rect.x = rect.x - entity_rect.width
    entity.collisions["right"] = true
   }

   if frame_movement.x < 0 {
    entity_rect.x = rect.x + rect.width
    entity.collisions["left"] = true
   }
   entity.pos.x = entity_rect.x
  }
 }

 entity.pos.y += frame_movement.y

 entity_rect2 : rl.Rectangle = rect(entity)

 for rect in physics_rects_around(&gameState.tilemap, entity.pos) {
  if rl.CheckCollisionRecs(entity_rect2, rect) {
   if frame_movement.y > 0 {
    entity_rect2.y = rect.y - entity_rect2.height
    entity.collisions["down"] = true
    if entity.e_type == "player" {
     if gameState.jumps < 2 {
      gameState.jumps = 2
     }
    }
   }
   if frame_movement.y < 0 {
    entity_rect2.y = rect.y + rect.height
    entity.collisions["up"] = true
   }

   entity.pos.y = entity_rect2.y
  }
 }

 entity.velocity.y = min(5, entity.velocity.y+0.1)

 // buf := []byte{0}
 // rl.TraceLog(rl.TraceLogLevel.INFO, strings.clone_to_cstring(strconv.itoa(buf, int(entity.velocity.y))))

 if movement.x > 0 {
 entity.flip = false
}

 if movement.x < 0 {
 entity.flip = true
}

 if entity.collisions["down"] || entity.collisions["up"] {
  entity.velocity.y = 0
 }

 if entity.e_type == "player" {
  update_player(entity, assets, movement)
 }
}

render_entity :: proc(entity: ^PhysicsEntity, assets: ^Assets, offset: rl.Vector2) {
  pos := rl.Vector2{entity.pos.x - offset.x, entity.pos.y - offset.y}
  flip :f32 = entity.flip ? 1.0 : -1.0
  rl.DrawTextureEx(assets.player, pos, 0, flip, rl.WHITE)
  // rl.DrawTexture(assets.player, i32(entity.pos.x - offset.x), i32(entity.pos.y - offset.y), rl.WHITE)
}

update_player :: proc(entity: ^PhysicsEntity, assets: ^Assets, movement: rl.Vector2) {
 entity.air_time += 1

 if entity.collisions["down"] {
  entity.air_time = 0
 }

 if entity.air_time > 4 {
  set_action(entity, "jump", assets)
 } else if movement.x != 0 {
  set_action(entity, "run", assets)
 } else {
  set_action(entity, "idle", assets)
 }
}
