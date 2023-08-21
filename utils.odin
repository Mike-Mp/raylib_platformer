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
  for img in files {
   append(&images, rl.LoadTexture(strings.clone_to_cstring(img.fullpath)))
  }
 }

 return images
}

Animation :: struct {
 images: [dynamic]rl.Texture2D,
 loop: bool,
 img_duration: int,
 done: bool,
 frame: int,
} 

create_animation :: proc(images: [dynamic]rl.Texture2D, img_dur : int = 5, loop : bool = true) ->Animation{
 return Animation {
  images= images,
  loop=loop,
  img_duration=img_dur,
  done= false,
  frame= 0,
 }
}

copy_animation :: proc(anim: ^Animation) ->Animation{
 return create_animation(anim.images, anim.img_duration, anim.loop) 
}

update_animation :: proc(anim: ^Animation) {
 if anim.loop {
  anim.frame = (anim.frame + 1) % (anim.img_duration * len(anim.images))
 } else {
  anim.frame = min(anim.frame + 1, anim.img_duration * len(anim.images) - 1)
  if anim.frame >= anim.img_duration * len(anim.images) - 1 {
   anim.done = true
  }
 }
}

img_animation :: proc(anim: ^Animation) ->rl.Texture2D {
 return anim.images[int(anim.frame / anim.img_duration)]
}
