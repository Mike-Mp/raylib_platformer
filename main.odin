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

	cloudPos : rl.Vector2,
	cloudMov : rl.Vector2,

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
	tesst : PhysicsEntity

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

	gameState.cloudPos = rl.Vector2{160.0, 260.0}
	gameState.cloudMov = rl.Vector2{0, 0}

	gameState.collision_area = rl.Rectangle{50,50,300,50}

	gameState.tilemap = init_tilemap()

	assets.clouds = rl.LoadTexture("assets/images/clouds/cloud_1.png")
	assets.bg = rl.LoadTexture("assets/images/background.png")

	assets.assets["decor"] = load_images("tiles/decor")	
	assets.assets["grass"]	=	load_images("tiles/grass")
	assets.assets["large_decor"]	=	load_images("tiles/large_decor")
	assets.assets["stone"]	=	load_images("tiles/stone")

	assets.player = load_image("entities/player.png")

	gameState.player = new_entity("player", rl.Vector2{50,50}, rl.Vector2{8,15})

	return gameState, assets
}

draw_game :: proc(assets: ^Assets, gameState: ^GameState, target: rl.RenderTexture2D) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(rl.RAYWHITE)
	rl.BeginTextureMode(target)

	rl.ClearBackground(rl.BLANK)

	render_tilemap(&gameState.tilemap, assets)

	rl.DrawTexture(assets.bg, 0, 0, rl.WHITE)

	img_r := rl.Rectangle{gameState.cloudPos.x, gameState.cloudPos.y, f32(assets.clouds.width), f32(assets.clouds.height)}

	if rl.CheckCollisionRecs(gameState.collision_area, img_r) {
		rl.DrawRectangleRec(gameState.collision_area, rl.BLUE)	
	} else {
		rl.DrawRectangleRec(gameState.collision_area, rl.LIGHTGRAY)	
	}

	rl.EndTextureMode()

	rl.DrawTexture(assets.clouds, i32(gameState.cloudPos.x), i32(gameState.cloudPos.y), rl.WHITE)
	rl.DrawTexturePro(target.texture, rl.Rectangle{0,0, f32(target.texture.width), f32(-target.texture.height)}, rl.Rectangle{0,0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}, rl.Vector2{0,0}, 0,rl.WHITE)
}

update_game :: proc (gameState: ^GameState, assets: ^Assets) {
	gameState.cloudPos.y += (gameState.cloudMov.y - gameState.cloudMov.x) * 5
}
 
input :: proc (gameState: ^GameState) {
	if rl.IsKeyPressed(rl.KeyboardKey.DOWN) {
		gameState.cloudMov.y = 1
	}

	if rl.IsKeyPressed(rl.KeyboardKey.UP) {
		gameState.cloudMov.x = 1
	}

	if rl.IsKeyReleased(rl.KeyboardKey.DOWN) {
		gameState.cloudMov.y = 0
	}

	if rl.IsKeyReleased(rl.KeyboardKey.UP) {
		gameState.cloudMov.x = 0
	}
}
