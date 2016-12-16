// ---------------------------------------
// Sprite definitions for 'kenneyTiles'
// Generated with TexturePacker 4.3.1
//
// http://www.codeandweb.com/texturepacker
// ---------------------------------------

import SpriteKit


class kennyTiles {

    // sprite names
    let COLUMN_E     = "column_E"
    let COLUMN_N     = "column_N"
    let COLUMN_S     = "column_S"
    let COLUMN_W     = "column_W"
    let FLOORGRASS_E = "floorGrass_E"
    let FLOORGRASS_N = "floorGrass_N"
    let FLOORGRASS_S = "floorGrass_S"
    let FLOORGRASS_W = "floorGrass_W"
    let FLOOR_E      = "floor_E"
    let FLOOR_N      = "floor_N"
    let FLOOR_S      = "floor_S"
    let FLOOR_W      = "floor_W"
    let SLAB_E       = "slab_E"
    let SLAB_N       = "slab_N"
    let SLAB_S       = "slab_S"
    let SLAB_W       = "slab_W"


    // load texture atlas
    let textureAtlas = SKTextureAtlas(named: "kenneyTiles")


    // individual texture objects
    func column_E() -> SKTexture     { return textureAtlas.textureNamed(COLUMN_E) }
    func column_N() -> SKTexture     { return textureAtlas.textureNamed(COLUMN_N) }
    func column_S() -> SKTexture     { return textureAtlas.textureNamed(COLUMN_S) }
    func column_W() -> SKTexture     { return textureAtlas.textureNamed(COLUMN_W) }
    func floorGrass_E() -> SKTexture { return textureAtlas.textureNamed(FLOORGRASS_E) }
    func floorGrass_N() -> SKTexture { return textureAtlas.textureNamed(FLOORGRASS_N) }
    func floorGrass_S() -> SKTexture { return textureAtlas.textureNamed(FLOORGRASS_S) }
    func floorGrass_W() -> SKTexture { return textureAtlas.textureNamed(FLOORGRASS_W) }
    func floor_E() -> SKTexture      { return textureAtlas.textureNamed(FLOOR_E) }
    func floor_N() -> SKTexture      { return textureAtlas.textureNamed(FLOOR_N) }
    func floor_S() -> SKTexture      { return textureAtlas.textureNamed(FLOOR_S) }
    func floor_W() -> SKTexture      { return textureAtlas.textureNamed(FLOOR_W) }
    func slab_E() -> SKTexture       { return textureAtlas.textureNamed(SLAB_E) }
    func slab_N() -> SKTexture       { return textureAtlas.textureNamed(SLAB_N) }
    func slab_S() -> SKTexture       { return textureAtlas.textureNamed(SLAB_S) }
    func slab_W() -> SKTexture       { return textureAtlas.textureNamed(SLAB_W) }

}
