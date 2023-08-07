package main

import "core:strings"
import "core:fmt"

import rl "vendor:raylib"

NEIGHBOR_OFFSETS :: [9][2]int{{-1,0}, {-1,-1}, {0,-1}, {1,-1}, {1,0}, {0,0}, {-1,1}, {0,1}, {1,1}}

Tile :: struct {
 type: string,
 variant: u8,
 pos: rl.Vector2,
}

Tilemap :: struct {
	tile_size: int,
  tiles: map[string]Tile,
	offgrid_tiles: [dynamic]Tile,
}

init_tilemap :: proc(tile_size :int =16) -> Tilemap {
  tilemap := Tilemap{}

  for i in 0..=10 {
   tilemap.tiles[strings.concatenate({fmt.aprint(3+i),";10"})] = Tile{type="grass", variant=1, pos=rl.Vector2{3+f32(i),10}}
   tilemap.tiles[strings.concatenate({"10;" , fmt.aprint(5+i)})] = Tile{type="stone", variant=1, pos=rl.Vector2{10,5+f32(i)}}

   rl.TraceLog(rl.TraceLogLevel.INFO, strings.clone_to_cstring(strings.concatenate({fmt.aprint(3+i),";10"})))
   rl.TraceLog(rl.TraceLogLevel.INFO, "------------------")
   rl.TraceLog(rl.TraceLogLevel.INFO, strings.clone_to_cstring(strings.concatenate({"10;" , fmt.aprint(5+i)})))
  }

  tilemap.tile_size = tile_size

  return tilemap
}

tiles_around :: proc(tilemap: ^Tilemap, pos: rl.Vector2) -> [dynamic]Tile {
 tiles := [dynamic]Tile{}

 // %% modulo with floored division
 tile_loc := [2]int{int(pos.x)%%tilemap.tile_size, int(pos.y)%%tilemap.tile_size} 

 for offset in NEIGHBOR_OFFSETS {
  check_loc := strings.concatenate({fmt.aprint(tile_loc[0] + offset[0]) , ";", fmt.aprint(tile_loc[1] + offset[1])})

  if check_loc in tilemap.tiles {
   append(&tiles, tilemap.tiles[check_loc])
  }
 }

 return tiles
}

physics_rects_around :: proc(tilemap: ^Tilemap, pos: rl.Vector2) -> [dynamic]rl.Rectangle {
 rects := [dynamic]rl.Rectangle{}

 for tile in tiles_around(tilemap, pos) {
  if tile.type == "grass" || tile.type == "stone" {
   append(&rects, rl.Rectangle{tile.pos.x*f32(tilemap.tile_size), tile.pos.y*f32(tilemap.tile_size), f32(tilemap.tile_size), f32(tilemap.tile_size)})
  }
 }

 return rects
}

render_tilemap :: proc(tilemap: ^Tilemap, assets: ^Assets) {
 for tile in tilemap.offgrid_tiles {
  rl.DrawTexture(assets.assets[tile.type][tile.variant], i32(tile.pos.x), i32(tile.pos.y), rl.WHITE)
 }

 for loc in tilemap.tiles {
  tile := tilemap.tiles[loc]
  rl.DrawTexture(assets.assets[tile.type][tile.variant], i32(tile.pos.x * f32(tilemap.tile_size)), i32(tile.pos.y * f32(tilemap.tile_size)), rl.WHITE)
 }
}
