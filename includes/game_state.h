#ifndef GAME_STATE_H
#define GAME_STATE_H

#include <raylib.h>

typedef struct {
  int playerX;
  int playerY;
  int playerHP;

  Vector2 cloudPos;
  Vector2 cloudMov;
} GameState;

typedef struct {
  Texture2D clouds;
  Texture2D bg;
} Assets;

#endif
