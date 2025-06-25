/// @desc Draws text scaled
/// @param {Real} x 
/// @param {Real} y 
/// @param {Real} scale 
/// @param {String} text
/// @param {Constant.Color} [color] 
/// @param {Real} [alpha] 
function draw_text_scale(x, y, scale, text, color = c_white, alpha = 1) {
    draw_set_font(fnt_RetroPixel);
    draw_set_color(color);
    draw_set_alpha(alpha);
    draw_text_transformed(x, y, text, scale, scale, 0);
    draw_set_alpha(1);
}