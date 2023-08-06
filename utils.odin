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
 hdl, err := os.open(url)

 files, err2 := os.read_dir(hdl, 0) 

 if err2 == os.ERROR_NONE {
  for img,i in files {
   append(&images, rl.LoadTexture(strings.clone_to_cstring(img.fullpath)))
  }
 }

 return images
}

