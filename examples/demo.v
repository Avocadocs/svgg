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
