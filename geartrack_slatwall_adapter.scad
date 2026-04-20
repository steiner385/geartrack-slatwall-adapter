// GearTrack-to-Slatwall Adapter
// Slides into Gladiator GearTrack/GearWall channels and presents
// a standard slatwall panel face with full-width horizontal T-grooves.
//
// Self-contained — no external dependencies.
// GearTrack bracket profile derived from CosmicProphet's GearTrack
// Mounting Brackets (Thingiverse thing:4075984), CC BY 4.0.
// Slatwall groove profile derived from Thingiverse thing:153058 and
// thing:5878930.
//
// Print settings:
//   Orientation: flat on bed (panel face down)
//   Infill: 50-80%, rectilinear
//   Perimeters: 3+
//   Material: PLA or PETG (PETG recommended for garage use)
//   Supports: not required

/* [Slatwall Panel] */

// Panel width in mm (horizontal, along the track). Even column count.
panel_width = 4; // [2, 4, 6, 8]

// Number of slatwall groove rows (vertical, 3" / 76.2mm apart)
groove_rows = 2; // [1:1:4]

/* [Groove Dimensions] */

// Groove opening width in mm (narrow front slit)
groove_opening = 5.0; // [4:0.5:7]

// T-channel width in mm (wider space behind the lip)
groove_channel_w = 15.0; // [12:0.5:18]

// T-channel depth in mm (how deep behind the front face)
groove_channel_d = 10.0; // [8:0.5:14]

// Front face thickness in mm (material in front of T-channel)
face_thick = 6.0; // [4:0.5:8]

/* [Panel Layout] */

// Groove spacing center-to-center in mm (standard = 76.2 / 3 inches)
groove_spacing = 76.2;

// Margin above/below outermost grooves in mm
margin_v = 15.0; // [10:1:25]

// Column spacing for tab distribution (same as pegboard adapter)
col_spacing = 25.4; // 1 inch, for tab placement math

/* [Standoff] */

// Space between GearTrack face and panel back (mm)
standoff = 5.0; // [0:1:15]

// Rib thickness in mm
rib_thick = 4.0; // [3:0.5:6]

// Gusset size in mm
gusset = 7.0; // [4:0.5:12]

/* [Advanced] */

// Tab width in mm (along the track)
tab_width = 10; // [8:1:14]

// Print just one bracket tab to test GearTrack fit
test_clip = false;

/* [Hidden] */

$fn = 40;

// ----- GEARTRACK BRACKET PROFILE -----
_bracket_profile = [
    [  -6.000,  -62.467],
    [  10.600,  -61.867],
    [  10.000,   19.733],
    [  -4.990,   20.143],
    [  -5.400,   21.133],
    [  -5.400,   31.733],
    [  -5.753,   31.733],
    [  -8.600,   26.039],
    [  -8.600,   12.592],
    [  -7.620,    7.533],
    [  -5.400,    7.533],
    [  -4.823,   12.266],
    [  -4.000,   12.533],
    [   2.990,   12.123],
    [   3.400,   11.133],
    [   2.990,  -56.857],
    [   2.000,  -57.267],
    [ -10.600,  -57.867],
    [ -10.600,  -64.344],
    [  -9.699,  -67.467],
    [  -7.400,  -67.467],
    [  -6.823,  -62.734],
    [  -6.219,  -62.484]
];

module bracket_tab() {
    linear_extrude(height = tab_width)
        polygon(points = _bracket_profile);
}

// ----- DERIVED -----
// Total plate thickness = front face + T-channel depth
plate_thick = face_thick + groove_channel_d;

// Panel dimensions
plate_w = (panel_width - 1) * col_spacing + 2 * 10;  // horizontal (along track)
plate_h = (groove_rows - 1) * groove_spacing + 2 * margin_v;  // vertical

// Tab count: 1 per 4 columns of width
num_tabs = max(1, ceil(panel_width / 4));

bracket_height = 100;
bracket_y_min  = -68;
bracket_front  = 11;

num_gaps = panel_width - 1;

function tab_gap_index(i, n, gaps) =
    (n == 1) ? floor(gaps / 2) :
    floor(i * (gaps - 1) / (n - 1));

function gap_z(gap_idx) =
    10 + (gap_idx + 0.5) * col_spacing;

// ----- MODULES -----

// Full-width T-groove cut — extends through panel AND ribs/gussets behind it
// so slatwall hooks can slide freely along the full width
module groove_cut() {
    // Front narrow opening (through the face)
    translate([-1, -groove_opening / 2, -1])
        cube([face_thick + 2, groove_opening, plate_w + 2]);

    // Rear T-channel — extends back through ribs and standoff
    translate([face_thick, -groove_channel_w / 2, -1])
        cube([groove_channel_d + standoff + 20, groove_channel_w, plate_w + 2]);
}

// Slatwall panel (solid block — grooves cut in assembly)
module slatwall_panel() {
    cube([plate_thick, plate_h, plate_w]);
}

// Short rib segment for a solid band between grooves
module rib_segment(seg_h) {
    cube([standoff, seg_h, rib_thick]);
}

module gusset_wedge(leg_x, leg_z, h) {
    polyhedron(
        points = [
            [0, 0, 0], [leg_x, 0, 0], [0, 0, leg_z],
            [0, h, 0], [leg_x, h, 0], [0, h, leg_z]
        ],
        faces = [
            [0, 2, 1], [3, 4, 5],
            [0, 1, 4, 3], [1, 2, 5, 4], [0, 3, 5, 2]
        ]
    );
}

// ----- ASSEMBLY -----

if (test_clip) {
    bracket_tab();
} else {
    plate_y_offset = bracket_y_min + (bracket_height - plate_h) / 2;
    panel_x = bracket_front + standoff;

    // Bracket tabs
    for (i = [0 : num_tabs - 1]) {
        gi = tab_gap_index(i, num_tabs, num_gaps);
        tz = gap_z(gi);
        translate([0, 0, tz - tab_width / 2])
            bracket_tab();
    }

    // Ribs — only in solid bands between grooves (not crossing groove channels)
    // Solid bands: bottom margin, between each groove pair, top margin
    // Groove centers are at: margin_v, margin_v + groove_spacing, ...
    // Groove channel occupies: center - groove_channel_w/2 to center + groove_channel_w/2
    if (standoff > 0) {
        for (i = [0 : num_tabs - 1]) {
            gi = tab_gap_index(i, num_tabs, num_gaps);
            tz = gap_z(gi);

            // Bottom margin band: Y=0 to first groove bottom edge
            bot_band_top = margin_v - groove_channel_w / 2;
            if (bot_band_top > 1)
                translate([bracket_front, plate_y_offset, tz - rib_thick / 2])
                    rib_segment(bot_band_top);

            // Bands between grooves
            for (r = [0 : groove_rows - 2]) {
                band_bot = margin_v + r * groove_spacing + groove_channel_w / 2;
                band_top = margin_v + (r + 1) * groove_spacing - groove_channel_w / 2;
                band_h = band_top - band_bot;
                if (band_h > 1)
                    translate([bracket_front, plate_y_offset + band_bot, tz - rib_thick / 2])
                        rib_segment(band_h);
            }

            // Top margin band: last groove top edge to plate_h
            top_band_bot = margin_v + (groove_rows - 1) * groove_spacing + groove_channel_w / 2;
            top_band_h = plate_h - top_band_bot;
            if (top_band_h > 1)
                translate([bracket_front, plate_y_offset + top_band_bot, tz - rib_thick / 2])
                    rib_segment(top_band_h);
        }
    }

    // Slatwall panel with grooves cut
    difference() {
        translate([panel_x, plate_y_offset, 0])
            slatwall_panel();

        for (r = [0 : groove_rows - 1]) {
            translate([panel_x, plate_y_offset + margin_v + r * groove_spacing, 0])
                groove_cut();
        }
    }
}
