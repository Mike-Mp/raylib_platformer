package main

import "core:os"
import "core:fmt"
import "core:strings"

import rl "vendor:raylib"

// BASE_IMG_PATH :: "assets/images/"

load_image :: proc(path: string) -> rl.Texture2D {
 base_img_path : string = "assets/images/"
 url := strings.concatenate({base_img_path, path})
 img := rl.LoadTexture(strings.clone_to_cstring(url))
 free(&url)
 return img
}

load_images :: proc(path: string) -> [dynamic]rl.Texture2D {
 images := [dynamic]rl.Texture2D{}

 base_img_path : string = "assets/images/"

 url := strings.concatenate({base_img_path, path})
 hdl := os.Handle{} 
 files, err := os.read_dir(hdl, 5) 
 free(&url)

 if err == os.ERROR_NONE {
  for img,i in files {
   rl.TraceLog(rl.TraceLogLevel.INFO, strings.clone_to_cstring(img.fullpath))
  }
 }


 return images
}

