import gg
import gx
import svgg
import iui as ui
import iui.dialogs as dialog
import os

@[heap]
struct App {
mut:
	id        int
	img       &ui.Image
	is_init   bool
	rastercfg svgg.RasterizeCfg
	file      string
}

fn main() {
	mut win := ui.Window.new(
		title:  'SVGG Example with iUI'
		width:  800
		height: 600
		theme:  ui.theme_dark()
	)

	mut app := App{
		img:       ui.Image.new(pack: true)
		rastercfg: svgg.RasterizeCfg{}
		file:      os.resource_abs_path('./23.svg')
	}
	app.img.subscribe_event('draw', app.image_draw_event)

	// Create Content/Root Panel
	mut content := ui.Panel.new(
		layout: ui.BorderLayout.new()
	)

	// Create Center Panel
	mut image_panel := ui.ScrollView.new(
		view: app.img
	)

	// Create South Panel
	mut south := ui.Panel.new(
		layout:   ui.GridLayout.new(
			vgap: 0
			cols: 3
		)
		children: [
			ui.Button.new(
				text:     'Scale / 2'
				on_click: app.half_scale_click
			),
			ui.Button.new(
				text:     'Scale * 2'
				on_click: app.double_scale_click
			),
			ui.Button.new(
				text:     'Load SVG..'
				on_click: app.open_btn_event
			),
		]
	)
	south.height = 32

	// Add Panels to Content/Root Panel
	content.add_child(image_panel, value: ui.borderlayout_center)
	content.add_child(south, value: ui.borderlayout_south)
	win.add_child(content)

	// Run Window
	win.run()
}

fn (mut app App) half_scale_click(mut e ui.MouseEvent) {
	if app.rastercfg.scale <= 0.125 {
		return
	}

	app.rastercfg = svgg.RasterizeCfg{
		width:  app.img.width / 2
		height: app.img.height / 2
		scale:  app.rastercfg.scale / 2.0
	}
	app.remake(mut e.ctx.gg)
	app.img.need_pack = true
}

fn (mut app App) double_scale_click(mut e ui.MouseEvent) {
	app.rastercfg = svgg.RasterizeCfg{
		width:  app.img.width * 2
		height: app.img.height * 2
		scale:  app.rastercfg.scale * 2.0
	}
	app.remake(mut e.ctx.gg)
}

fn (mut app App) open_btn_event(mut e ui.MouseEvent) {
	value := dialog.open_dialog('Select SVG..')

	if !os.exists(value) {
		return
	}

	app.file = value
	app.rastercfg = svgg.RasterizeCfg{
		scale: 1
	}
	app.remake(mut e.ctx.gg)
	app.img.need_pack = true
}

// Load Image if image is unloaded
fn (mut app App) image_draw_event(mut e ui.DrawEvent) {
	if !app.is_init {
		app.init(mut e.ctx.gg)
		app.is_init = true
	}
}

fn (mut a App) init(mut ctx gg.Context) {
	_, a.id = svgg.create_svg_image_id(mut ctx, a.file, a.rastercfg)
	a.img.img_id = a.id
}

fn (mut a App) remake(mut ctx gg.Context) {
	ctx.remove_cached_image_by_idx(a.id)
	a.init(mut ctx)
}
