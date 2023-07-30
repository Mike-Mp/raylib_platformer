#include "raylib.h"
#include <stdio.h>

int main() {
  const int screenWidth = 800;
  const int screenHeight = 800;

  InitWindow(screenWidth, screenHeight, "raylib platformer");

  SetTargetFPS(60);

  Texture2D bgTexture = LoadTexture("assets/images/background.png");
  char char_arr[100];
  sprintf(char_arr, "%d", bgTexture.width);

  const char *num_str = char_arr;

  TraceLog(LOG_INFO, num_str);
  TraceLog(LOG_INFO, "hello");

  while (!WindowShouldClose()) {
    BeginDrawing();

    ClearBackground(RAYWHITE);

    DrawTexture(bgTexture, 0, 0, WHITE);

    DrawText("Congratz! You created your first window!", 190, 200, 20,
             LIGHTGRAY);

    EndDrawing();
  }

  UnloadTexture(bgTexture);

  CloseWindow();

  return 0;
}
