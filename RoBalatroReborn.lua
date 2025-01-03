--- STEAMODDED HEADER

--- MOD_NAME: Ro-Balatro Reborn
--- MOD_ID: robalatroreborn
--- MOD_AUTHOR: [AlexZGreat]
--- MOD_DESCRIPTION: Remake of Ro-Balatro
--- PRIORITY: -200
--- BADGE_COLOR: fd5f55
--- PREFIX: roblr
--- VERSION: 1.0
--- LOADER_VERSION_GEQ: 1.0.0

--Mod icon
SMODS.Atlas{
    key = "modicon",
    path = "robalatro_modicon.png",
    px = 34,
    py = 34,
}

--Load files
assert(SMODS.load_file("objects/sounds.lua"))()
assert(SMODS.load_file("objects/gears.lua"))()
assert(SMODS.load_file("objects/boosters.lua"))()
