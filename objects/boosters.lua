SMODS.Atlas{
	key = "booster_atlas",
	px = 70,
	py = 95,
	path = "robalatro-packs.png",
}

SMODS.Booster {
    key = 'gear_normal_1',
    atlas = "booster_atlas",
    pos = {
        x = 0,
        y = 0,
    },
    weight = 0.3,
    cost = 4,
 	loc_txt = {
 		name = 'Gear Pack',
 		group_name = 'Gear Pack',
 		text = {
            "Choose {C:attention}#2# of up to",
            "{C:attention}#1# {C:money}Gear{} cards to be",
            "obtained"
        },
 	},
    config = {extra = 2, choose = 1, name = "Gear Pack"},
    create_card = function(self, card)
        return create_card("gear", G.pack_cards, nil, nil, true,  true, nil, "gearpack")
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.MONEY)
        ease_background_colour{new_colour = G.C.MONEY, special_colour = darken(G.C.BLUE,0.4), contrast = 4}
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.MONEY, darken(G.C.MONEY, 0.2), G.C.BLUE, darken(G.C.BLUE, 0.1)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}

SMODS.Booster {
    key = 'gear_normal_2',
    atlas = "booster_atlas",
    pos = {
        x = 1,
        y = 0,
    },
    weight = 0.3,
    cost = 4,
 	loc_txt = {
 		name = 'Gear Pack',
 		group_name = 'Gear Pack',
 		text = {
            "Choose {C:attention}#2# of up to",
            "{C:attention}#1# {C:money}Gear{} cards to be",
            "obtained"
        },
 	},
    config = {extra = 2, choose = 1, name = "Gear Pack"},
    create_card = function(self, card)
        return create_card("gear", G.pack_cards, nil, nil, true,  true, nil, "gearpack")
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.MONEY)
        ease_background_colour{new_colour = G.C.MONEY, special_colour = darken(G.C.BLUE,0.4), contrast = 4}
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.MONEY, darken(G.C.MONEY, 0.2), G.C.BLUE, darken(G.C.BLUE, 0.1)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}

SMODS.Booster {
    key = 'gear_big_1',
    atlas = "booster_atlas",
    pos = {
        x = 2,
        y = 0,
    },
    weight = 0.3,
    cost = 6,
 	loc_txt = {
 		name = 'Jumbo Gear Pack',
 		group_name = 'Gear Pack',
 		text = {
            "Choose {C:attention}#2# of up to",
            "{C:attention}#1# {C:money}Gear{} cards to be",
            "obtained"
        },
 	},
    config = {extra = 4, choose = 1, name = "Gear Pack"},
    create_card = function(self, card)
        return create_card("gear", G.pack_cards, nil, nil, true,  true, nil, "gearpack")
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.MONEY)
        ease_background_colour{new_colour = G.C.MONEY, special_colour = darken(G.C.BLUE,0.4), contrast = 4}
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.MONEY, darken(G.C.MONEY, 0.2), G.C.BLUE, darken(G.C.BLUE, 0.1)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}

SMODS.Booster {
    key = 'gear_huge_1',
    atlas = "booster_atlas",
    pos = {
        x = 3,
        y = 0,
    },
    weight = 0.04,
    cost = 8,
 	loc_txt = {
 		name = 'Mega Gear Pack',
 		group_name = 'Gear Pack',
 		text = {
            "Choose {C:attention}#2# of up to",
            "{C:attention}#1# {C:money}Gear{} cards to be",
            "obtained"
        },
 	},
    config = {extra = 4, choose = 2, name = "Gear Pack"},
    create_card = function(self, card)
        return create_card("gear", G.pack_cards, nil, nil, true,  true, nil, "gearpack")
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.MONEY)
        ease_background_colour{new_colour = G.C.MONEY, special_colour = darken(G.C.BLUE,0.4), contrast = 4}
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.MONEY, darken(G.C.MONEY, 0.2), G.C.BLUE, darken(G.C.BLUE, 0.1)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}

--make gear packs keep the cards (code taken from cryptid)
local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a keep button
        if card.ability.set == "gear" then
            return {
                n = G.UIT.ROOT,
                config = { padding = -0.1, colour = G.C.CLEAR },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = {
                            ref_table = card,
							r = 0.08,
							padding = 0.1,
							align = "tm",
							minw = 0.5 * card.T.w - 0.15,
							maxw = 0.9 * card.T.w - 0.15,
							minh = 0.1 * card.T.h,
							hover = true,
							shadow = true,
                            colour = G.C.UI.BACKGROUND_INACTIVE,
                            one_press = true,
                            button = "use_card",
                            func = "can_reserve_card",
                        },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = {
                                    text = "Equip",
                                    colour = G.C.UI.TEXT_LIGHT,
                                    scale = 0.55,
                                    shadow = true,
                                },
                            },
                        },
                    },
                    -- good luck
                },
            }
        end
    end
    return G_UIDEF_use_and_sell_buttons_ref(card)
end
G.FUNCS.can_reserve_card = function(e)
    if #G.consumeables.cards < G.consumeables.config.card_limit then
        e.config.colour = G.C.BLUE
        e.config.button = "reserve_card"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end
G.FUNCS.reserve_card = function(e)
    local c1 = e.config.ref_table
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.1,
        func = function()
            c1.area:remove_card(c1)
            c1:add_to_deck()
            if c1.children.price then
                c1.children.price:remove()
            end
            c1.children.price = nil
            if c1.children.buy_button then
                c1.children.buy_button:remove()
            end
            c1.children.buy_button = nil
            remove_nils(c1.children)
            G.consumeables:emplace(c1)
            G.GAME.pack_choices = G.GAME.pack_choices - 1
            if G.GAME.pack_choices <= 0 then
                G.FUNCS.end_consumeable(nil, delay_fac)
            end
            return true
        end,
    }))
end