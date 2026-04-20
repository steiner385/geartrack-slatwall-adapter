# GearTrack Slatwall Adapter

A 3D-printable adapter that slides into Gladiator GearTrack/GearWall channels and presents a standard slatwall panel face with full-width horizontal T-grooves — so you can use your existing slatwall hooks and accessories on GearTrack.

## Features

- **Exact GearTrack fit** — bracket profile traced from [CosmicProphet's GearTrack Mounting Brackets](https://www.thingiverse.com/thing:4075984)
- **Self-contained** — single OpenSCAD file, no external dependencies
- **Standard slatwall grooves** — full-width horizontal T-slots, 3" (76.2mm) spacing
- **Fully parametric** — customize panel width, groove count, channel dimensions, and more
- **Unobstructed channels** — ribs placed only in solid bands between grooves, so hooks slide freely edge-to-edge
- **Smart tab distribution** — GearTrack tabs at the edges, evenly distributed

## Pre-generated STLs

| File | Panel Width | Grooves | Description |
|------|------------|---------|-------------|
| `Test_Clip` | — | — | Print first to verify GearTrack fit |
| `4x2` | 4-col (~96mm) | 2 | Compact, 2 hooks |
| `4x3` | 4-col (~96mm) | 3 | Compact, 3 hooks |
| `6x2` | 6-col (~147mm) | 2 | Wide, 2 hooks |
| `6x3` | 6-col (~147mm) | 3 | Wide, 3 hooks |
| `8x2` | 8-col (~198mm) | 2 | Max width, 2 hooks |
| `8x3` | 8-col (~198mm) | 3 | Max width, 3 hooks |

## Customizer Parameters

- **Panel width**: Columns across (even: 2, 4, 6, 8)
- **Groove rows**: Number of horizontal T-grooves (1–4)
- **Groove opening**: Narrow front slit width (4–7mm, default 5)
- **T-channel width**: Wider space behind lip (12–18mm, default 15)
- **T-channel depth**: Depth behind face (8–14mm, default 10)
- **Face thickness**: Material in front of T-channel (4–8mm, default 6)
- **Standoff**: Gap between GearTrack and panel back (0–15mm, default 5)
- **Test clip mode**: Print just the GearTrack tab to verify fit

## Print Settings

- **Orientation**: Flat on bed (panel face down)
- **Infill**: 50–80%, rectilinear
- **Perimeters**: 3+
- **Material**: PLA or PETG (PETG recommended for garage use)
- **Supports**: Not required

## Usage

1. Print the **Test Clip** first to verify it slides into your GearTrack
2. If too tight, scale the clip 99% in your slicer
3. Choose or customize a panel size
4. Print, slide into GearTrack from the end, and attach your slatwall hooks

## Attribution

- GearTrack bracket profile traced from [CosmicProphet's GearTrack Mounting Brackets](https://www.thingiverse.com/thing:4075984), CC BY 4.0
- Slatwall groove dimensions derived from [thing:153058](https://www.thingiverse.com/thing:153058) and [thing:5878930](https://www.thingiverse.com/thing:5878930)

## License

This work is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
