#include "../includes/game_state.h"
#include "raylib.h"

#include <stdio.h>
#include <stdlib.h>

GameState initGameState() {
  GameState gameState;

  gameState.playerX = 0;
  gameState.playerY = 0;
  gameState.playerHP = 100;

  gameState.cloudPos = (Vector2){160, 260};
  gameState.cloudMov = (Vector2){0, 0};

  return gameState;
}

Assets initAssets() {
  Assets assets;

  assets.clouds = LoadTexture("assets/images/clouds/cloud_1.png");
  assets.bg = LoadTexture("assets/images/background.png");

  return assets;
}

// void loadTextures(GameState *gameState) {
//   Texture2D clouds =

//
// }

const char *floatToString(float val) {
  char buffer[50];
  int charsWritten = snprintf(buffer, sizeof(buffer), "%f", val);

  if (charsWritten >= 0 && charsWritten < sizeof(buffer)) {
    char *result = (char *)malloc(charsWritten + 1);
    if (result != NULL) {
      snprintf(result, charsWritten + 1, "%s", buffer);
      return result;
    } else {
      return NULL;
    }
  } else {
    return NULL;
  }
}

void draw(Assets *assets, GameState *gameState) {
  BeginDrawing();

  ClearBackground(RAYWHITE);

  DrawTexture(assets->bg, 0, 0, WHITE);
  DrawTexture(assets->clouds, gameState->cloudPos.x, gameState->cloudPos.y,
              WHITE);

  // DrawText("Congratz! You created your first window!", 190, 200, 20,
  //          LIGHTGRAY);

  EndDrawing();
}

void update(GameState *gameState) {
  // TraceLog(LOG_INFO, floatToString(gameState->cloudMov.y));
  gameState->cloudPos.y += gameState->cloudMov.y - gameState->cloudMov.x;
}

void input(GameState *gameState) {
  if (IsKeyPressed(KEY_DOWN)) {
    gameState->cloudMov.y = 1;
  }
  if (IsKeyPressed(KEY_UP)) {
    gameState->cloudMov.x = 1;
  }

  if (IsKeyReleased(KEY_DOWN)) {
    gameState->cloudMov.y = 0;
  }
  if (IsKeyReleased(KEY_UP)) {
    gameState->cloudMov.x = 0;
  }
}

int main() {
  const int screenWidth = 640;
  const int screenHeight = 480;

  InitWindow(screenWidth, screenHeight, "raylib platformer");

  SetTargetFPS(60);

  Assets assets = initAssets();
  GameState gameState = initGameState();
  // char char_arr[100];
  // sprintf(char_arr, "%d", gameState.playerHP);

  // const char *num_str = char_arr;

  // TraceLog(LOG_INFO, num_str);
  // TraceLog(LOG_INFO, "hello");

  while (!WindowShouldClose()) {
    input(&gameState);
    update(&gameState);
    draw(&assets, &gameState);
  }

  UnloadTexture(assets.bg);
  UnloadTexture(assets.clouds);

  CloseWindow();

  return 0;
}
