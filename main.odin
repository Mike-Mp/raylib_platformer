package main

import "core:fmt"
import rl "vendor:raylib"

SCREEN_WIDTH :: 640
SCREEN_HEIGHT :: 480

GameState :: struct {
	// playerX : i32,
	// playerY : i32,
	playerHP : u8,

	player : PhysicsEntity,
	movement: rl.Vector2,

	clouds: [dynamic]Cloud,

	scroll: rl.Vector2,

	collision_area : rl.Rectangle,

	tilemap: Tilemap,
}

Assets :: struct {
	clouds: rl.Texture2D,
	bg: rl.Texture2D,

	assets: map[string][dynamic]rl.Texture2D,

	player: rl.Texture2D,
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Platformer")
	defer rl.CloseWindow()

	gameState : GameState
	assets : Assets

	gameState, assets = init_game()

	rl.SetTargetFPS(60)

  target : rl.RenderTexture2D	= rl.LoadRenderTexture(320,240)

	for !rl.WindowShouldClose() {
		input(&gameState)
		update_game(&gameState, &assets)
		draw_game(&assets, &gameState, target)
	}

	rl.UnloadRenderTexture(target)

	rl.UnloadTexture(assets.bg)
	rl.UnloadTexture(assets.clouds)
}

init_game :: proc() -> (GameState, Assets) {
	gameState : GameState
	assets : Assets

	// gameState.playerX = 0
	// gameState.playerY = 0
	gameState.playerHP = 100

	gameState.movement = rl.Vector2{0,0}

	gameState.collision_area = rl.Rectangle{50,50,300,50}

	gameState.tilemap = init_tilemap()

	assets.clouds = rl.LoadTexture("assets/images/clouds/cloud_1.png")
	assets.bg = rl.LoadTexture("assets/images/background.png")

	assets.assets["decor"] = load_images("tiles/decor")	
	assets.assets["grass"]	=	load_images("tiles/grass")
	assets.assets["large_decor"]	=	load_images("tiles/large_decor")
	assets.assets["stone"]	=	load_images("tiles/stone")
	assets.assets["clouds"]	=	load_images("clouds")

	gameState.clouds = init_clouds(assets.assets["clouds"])

	assets.player = load_image("entities/player.png")

	gameState.player = new_entity("player", rl.Vector2{50,50}, rl.Vector2{8,15})

	playerRect := rect(&gameState.player)

	playerRectCenters := rl.Vector2{(playerRect.x + playerRect.width)/2, (playerRect.y + playerRect.height)/2}

	gameState.scroll = rl.Vector2{ playerRectCenters.x - f32(rl.GetScreenWidth() / 2 - 0 / 30),
																 playerRectCenters.y - f32(rl.GetScreenHeight() / 2 - 0 / 30),
															 }

	return gameState, assets
}

draw_game :: proc(assets: ^Assets, gameState: ^GameState, target: rl.RenderTexture2D) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.BeginTextureMode(target)

	rl.ClearBackground(rl.BLANK)


	rl.DrawTexture(assets.bg, 0, 0, rl.WHITE)


	render_tilemap(&gameState.tilemap, assets)

	render_scroll := rl.Vector2{ gameState.scroll.x, gameState.scroll.y }

	render_clouds(&gameState.clouds, render_scroll)
	render_entity(&gameState.player, assets, render_scroll)

	rl.DrawTexture(assets.player, i32(gameState.player.pos.x), i32(gameState.player.pos.y), rl.WHITE)

	rl.EndTextureMode()

	rl.DrawTexturePro(target.texture, rl.Rectangle{0,0, f32(target.texture.width), f32(-target.texture.height)}, rl.Rectangle{0,0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}, rl.Vector2{0,0}, 0,rl.WHITE)
}

update_game :: proc (gameState: ^GameState, assets: ^Assets) {

	update_entity(gameState, &gameState.player, rl.Vector2{gameState.movement.y - gameState.movement.x, 0})

	for cloud in &gameState.clouds {
		update_cloud(&cloud)
	}

}
 
input :: proc (gameState: ^GameState) {
	if rl.IsKeyPressed(rl.KeyboardKey.LEFT) {
		gameState.movement.x = 1
	}

	if rl.IsKeyPressed(rl.KeyboardKey.RIGHT) {
		gameState.movement.y = 1
	}

	if rl.IsKeyReleased(rl.KeyboardKey.LEFT) {
		gameState.movement.x = 0
	}

	if rl.IsKeyReleased(rl.KeyboardKey.RIGHT) {
		gameState.movement.y = 0
	}
}
