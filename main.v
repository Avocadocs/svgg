module svgg

import gg

pub struct RasterizedImage {
pub:
	width  int
	height int
	data   []u8
}

pub struct RasterizeCfg {
pub:
	units  string = 'px'
	dpi    f32    = 96.0
	width  int    = -1
	height int    = -1
pub mut:
	scale f32 = 1.0
}

pub fn rasterize_svg_file(file string, cfg RasterizeCfg) RasterizedImage {
	svg := C.nsvgParseFromFile(file.str, cfg.units.str, cfg.dpi)

	if svg == 0 {
		panic('Failed to parse SVG.')
	}

	w := if cfg.width == -1 { int(svg.width) } else { cfg.width }
	h := if cfg.height == -1 { int(svg.height) } else { cfg.height }
	mut scale := cfg.scale

	mut buffer := []u8{len: w * h * 4}

	mut rasterizer := C.nsvgCreateRasterizer()
	defer {
		C.nsvgDeleteRasterizer(rasterizer)
	}

	C.nsvgRasterize(rasterizer, svg, 0, 0, scale, buffer.data, w, h, w * 4)

	return RasterizedImage{
		width:  w
		height: h
		data:   buffer
	}
}

fn create_image_from_raw_byte_array(mut ctx gg.Context, buf []u8, w int, h int) (gg.Image, int) {
	mut img := gg.Image{
		width:       w
		height:      h
		nr_channels: 4
		data:        buf.data
	}

	img.init_sokol_image()
	id := ctx.cache_image(img)

	return img, id
}

pub fn create_svg_image(mut ctx gg.Context, file string, cfg RasterizeCfg) gg.Image {
	rasterized_image := rasterize_svg_file(file, cfg)
	gg_image, _ := create_image_from_raw_byte_array(mut ctx, rasterized_image.data, rasterized_image.width,
		rasterized_image.height)

	return gg_image
}

pub fn create_svg_image_id(mut ctx gg.Context, file string, cfg RasterizeCfg) (gg.Image, int) {
	rasterized_image := rasterize_svg_file(file, cfg)
	gg_image, id := create_image_from_raw_byte_array(mut ctx, rasterized_image.data, rasterized_image.width,
		rasterized_image.height)

	return gg_image, id
}
