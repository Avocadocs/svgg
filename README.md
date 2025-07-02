# SVGG — SVG to `gg.Image` for V

**SVGG** is a small utility library for the [V programming language](https://vlang.io) that allows you to load and rasterize SVG files into `gg.Image` objects using the [`gg`](https://modules.vlang.io/gg.html) graphics module.

It uses [memononen/nanosvg](https://github.com/memononen/nanosvg) under the hood for SVG parsing and rasterization.

## Features

- Rasterizes `.svg` files to V `gg.Image`
- Simple API with optional configuration
- Integrates easily with any V `gg.Context`

## Installation

Clone the repository into your V module path or use it directly in your project.

```bash
git clone https://github.com/your-username/svgg.v
```

## Usage Example
```v
import gg
import gx
import svgg

@[heap]
struct App {
mut:
	img gg.Image
}

fn main() {
	mut app := App{}

	mut ctx := gg.new_context(
		width:        800
		height:       600
		window_title: 'SVGG Example'
		bg_color:     gx.light_blue
		init_fn:      app.init
		frame_fn:     app.frame
	)
	ctx.run()
}

fn (mut a App) init(mut ctx gg.Context) {
	a.img = svgg.create_svg_image(mut ctx, './23.svg', svgg.RasterizeCfg{})
}

fn (mut a App) frame(mut ctx gg.Context) {
	ctx.begin()
	ctx.draw_image(0, 0, a.img.width, a.img.height, a.img)
	ctx.end()
}
```

## License

This project is licensed under the MIT License.

It includes code from memononen/nanosvg, which is released under the Zlib license.
