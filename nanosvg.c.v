module svgg

#flag -I @VROOT/nanosvg

#define NANOSVG_IMPLEMENTATION
#include "nanosvg.h"
#define NANOSVGRAST_IMPLEMENTATION
#include "nanosvgrast.h"

@[typedef]
struct C.NSVGimage {
	width  f32
	height f32
	shapes voidptr
}

struct C.NSVGrasterizer {}

fn C.nsvgParseFromFile(path &char, units &char, dpi f32) &C.NSVGimage
fn C.nsvgDelete(image &C.NSVGimage)
fn C.nsvgCreateRasterizer() &C.NSVGrasterizer
fn C.nsvgRasterize(rast &C.NSVGrasterizer, image &C.NSVGimage, ox f32, oy f32,
	scale f32, dst &u8, w int, h int, stride int)
fn C.nsvgDeleteRasterizer(rast &C.NSVGrasterizer)
