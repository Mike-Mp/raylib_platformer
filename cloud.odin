package main

import "core:math/rand"
import "core:slice"
import "core:sort"

import rl "vendor:raylib"

Cloud :: struct {
 pos: rl.Vector2,
 img: rl.Texture2D,
 speed: f32,
 depth: f32,
}

update_cloud :: proc(cloud: ^Cloud) {
 cloud.pos.x += cloud.speed
}

render_cloud :: proc(cloud: ^Cloud, offset: rl.Vector2) {
 render_pos := rl.Vector2{cloud.pos.x - offset.x * cloud.depth, cloud.pos.y - offset.y * cloud.depth}

 rl.DrawTexture(cloud.img, (i32(render_pos.x) % rl.GetScreenWidth()+cloud.img.width) - cloud.img.width, i32(render_pos.y)%(rl.GetScreenHeight() + cloud.img.height) - cloud.img.height, rl.RAYWHITE)
}

init_clouds :: proc(cloud_images: [dynamic]rl.Texture2D, count :int = 16  ) -> [dynamic]Cloud {
 clouds := [dynamic]Cloud{}

 for i in 0..=count {
  cloud_pos := rl.Vector2{ rand.float32_range(0, 1.0) *9999, rand.float32_range(0,1)*9999}
  img_choice := rand.choice(cloud_images[:])
  append(&clouds, Cloud {pos=cloud_pos,  img=img_choice, speed=rand.float32_range(0,1)*0.05+0.05, depth=rand.float32_range(0,1)*0.6+0.2 })
 }

 slice.sort_by_key(clouds[:], proc(c: Cloud)->f32 {return c.depth})
 return clouds
}


render_clouds :: proc(clouds: ^[dynamic]Cloud, offset:rl.Vector2) {
 for cloud in clouds {
  render_cloud(&cloud, offset)
 }
}
