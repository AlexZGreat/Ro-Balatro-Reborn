--Create the gear consumable type
SMODS.ConsumableType{
	key = "gear",
	primary_colour = G.C.MONEY,
	secondary_colour = G.C.MONEY,
	loc_txt = {
		name = 'Gear',
		collection = 'Gear Cards',
		undiscovered = {
			name = 'Undiscovered',
			text = { 'Find this gear in a run!' },
		},
	},
	collection_rows = {6,6},
	default = "c_roblr_sword"
}

--Create the gear atlas
SMODS.Atlas{
	key = "gear_atlas",
	px = 70,
	py = 95,
	path = "robalatro-gears.png",
}

SMODS.UndiscoveredSprite{
	key = "gear",
	atlas = "gear_atlas",
	pos = {
		x=7,
		y=3,
		},
}

--Base gear class, contains common behaviors
SMODS.Gear = SMODS.Consumable:extend {
    set = 'gear',
    atlas = "roblr_gear_atlas",
	cost = 6,
	config = {extra = {currentuses = 3, maxuses = 3}},
	keep_on_use = function(self,card)
        if card.ability.extra.currentuses > 1 then
            return true
        end
    end,
	use = function(self,card,area,copier)
		card.ability.extra.currentuses = card.ability.extra.currentuses - 1
	end,
	--use function specifically for trowel, bloxy cola, etc
	enhancers = function(self,card,area,copier,enhancement1,enhancement2,edition,soundtable)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function() 
				for i, v in pairs (G.hand.highlighted) do
					if v.config.center_key == "m_" .. string.lower(enhancement1) then
						v:set_ability(G.P_CENTERS["m_" .. string.lower(enhancement2)])
						play_sound(soundtable[2].sound,soundtable[2].pitch,soundtable[2].volume)
					elseif v.config.center_key == "m_" .. string.lower(enhancement2) then
						if edition == "Holographic" then
							v:set_edition({holo = true},true,true)
						else
							v:set_edition({[string.lower(edition)] = true},true,true)
						end
						play_sound(soundtable[3].sound,soundtable[3].pitch,soundtable[3].volume)
					else
						v:set_ability(G.P_CENTERS["m_" .. string.lower(enhancement1)])
						play_sound(soundtable[1].sound,soundtable[1].pitch,soundtable[1].volume)
					end
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up(0.3, 0.4)
							return true
						end
					}))
				end
				return true end }))
	end,
}

SMODS.Gear{ --Sword
	key = "sword",
	pos = {
		x = 0,
		y = 0,
	},
	loc_txt = {
		name = "Sword",
		text = {
			"{C:attention}Destroys 2{} selected cards or",
			"{C:attention}Copies 1{} selected card",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 2, maxuses = 2}},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses}}
    end,
	can_use = function(self,card)
		if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
			if 2 >= #G.hand.highlighted then
				return true
			end
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		--copying (taken from cryptid (the card))
		if #G.hand.highlighted == 1 then
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function() 
                    local _first_dissolve = nil
            		local new_cards = {}
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local _card = copy_card(G.hand.highlighted[1], nil, nil, G.playing_card)
					_card:add_to_deck()
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, _card)
					G.hand:emplace(_card)
					_card:start_materialize(nil, _first_dissolve)
					_first_dissolve = true
					new_cards[#new_cards+1] = _card
					playing_card_joker_effects(new_cards)
					play_sound('roblr_SwordLunge', 1, 0.3)
                    return true end }))
		else
			--destruction (taken from hanged man)
			local destroyed_cards = {}
			for i=#G.hand.highlighted, 1, -1 do
                destroyed_cards[#destroyed_cards+1] = G.hand.highlighted[i]
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function() 
                    for i=#G.hand.highlighted, 1, -1 do
                        local _card = G.hand.highlighted[i]
                        if _card.ability.name == 'Glass Card' then 
                            _card:shatter()
                        else
                            _card:start_dissolve(nil, i == #G.hand.highlighted)
                        end
                    end
                	card:juice_up(0.3, 0.5)
                    return true end }))
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.05,
                func = function() 
                    play_sound('roblr_SwordSwing', 1, 1)
                    return true end }))
		end
	end,
}

SMODS.Gear{ --Trowel
	key = "trowel",
	pos = {
		x = 1,
		y = 0,
	},
	loc_txt = {
		name = "Trowel",
		text = {
			"Enhance 1 card to {C:attention}#3# Card",
			"If {C:attention}already #3#{}, convert to {C:attention}#4# Card",
			"If {C:attention}already #4#{}, apply {C:dark_edition}#5#",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 3, maxuses = 3, enhancement1 = "Bonus", enhancement2 = "Stone", edition = "Foil"}},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_" .. string.lower(card.ability.extra.enhancement1)]
		info_queue[#info_queue+1] = G.P_CENTERS["m_" .. string.lower(card.ability.extra.enhancement2)]
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses,card.ability.extra.enhancement1,card.ability.extra.enhancement2,card.ability.extra.edition}}
    end,
	can_use = function(self,card)
		if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
			if 1 >= #G.hand.highlighted then
				return true
			end
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		local soundtable = {
			{
				sound = "roblr_RobloxBass",
				pitch = 1,
				volume = 1,
			},
			{
				sound = "roblr_RobloxBass",
				pitch = 1.2,
				volume = 1,
			},
			{
				sound = "foil1",
				pitch = 1.2,
				volume = 0.4,
			},
		}
		SMODS.Gear.enhancers(self,card,area,copier,card.ability.extra.enhancement1,card.ability.extra.enhancement2,card.ability.extra.edition,soundtable)
	end,
}

SMODS.Gear{ --Bloxy Cola
	key = "bloxy_cola",
	pos = {
		x = 2,
		y = 0,
	},
	loc_txt = {
		name = "Bloxy Cola",
		text = {
			"Enhance 1 card to {C:attention}#3# Card",
			"If {C:attention}already #3#{}, convert to {C:attention}#4# Card",
			"If {C:attention}already #4#{}, apply {C:dark_edition}#5#",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 3, maxuses = 3, enhancement1 = "Mult", enhancement2 = "Lucky", edition = "Holographic"}},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_" .. string.lower(card.ability.extra.enhancement1)]
		info_queue[#info_queue+1] = G.P_CENTERS["m_" .. string.lower(card.ability.extra.enhancement2)]
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses,card.ability.extra.enhancement1,card.ability.extra.enhancement2,card.ability.extra.edition}}
    end,
	can_use = function(self,card)
		if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
			if 1 >= #G.hand.highlighted then
				return true
			end
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		local soundtable = {
			{
				sound = "roblr_BloxyCola",
				pitch = 1,
				volume = 1,
			},
			{
				sound = "roblr_BloxyCola",
				pitch = 1.2,
				volume = 1,
			},
			{
				sound = "holo1",
				pitch = 1.2*1.58,
				volume = 0.4,
			},
		}
		SMODS.Gear.enhancers(self,card,area,copier,card.ability.extra.enhancement1,card.ability.extra.enhancement2,card.ability.extra.edition,soundtable)
	end,
}

SMODS.Gear{ --Magic Carpet
	key = "magic_carpet",
	pos = {
		x = 3,
		y = 0,
	},
	loc_txt = {
		name = "Magic Carpet",
		text = {
			"Enhance 1 card to {C:attention}#3# Card",
			"If {C:attention}already #3#{}, convert to {C:attention}#4# Card",
			"If {C:attention}already #4#{}, apply {C:dark_edition}#5#",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 2, maxuses = 2, enhancement1 = "Steel", enhancement2 = "Glass", edition = "Polychrome"}},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_" .. string.lower(card.ability.extra.enhancement1)]
		info_queue[#info_queue+1] = G.P_CENTERS["m_" .. string.lower(card.ability.extra.enhancement2)]
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses,card.ability.extra.enhancement1,card.ability.extra.enhancement2,card.ability.extra.edition}}
    end,
	can_use = function(self,card)
		if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
			if 1 >= #G.hand.highlighted then
				return true
			end
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		local soundtable = {
			{
				sound = "roblr_RobloxButton",
				pitch = 1,
				volume = 1,
			},
			{
				sound = "roblr_RobloxButton",
				pitch = 1.2,
				volume = 1,
			},
			{
				sound = "polychrome1",
				pitch = 1.2,
				volume = 0.7,
			},
		}
		SMODS.Gear.enhancers(self,card,area,copier,card.ability.extra.enhancement1,card.ability.extra.enhancement2,card.ability.extra.edition,soundtable)
	end,
}

SMODS.Gear{ --Slingshot
	key = "slingshot",
	pos = {
		x = 4,
		y = 0,
	},
	loc_txt = {
		name = "Slingshot",
		text = {
			"Enhance 1 card to {C:attention}#3# Card",
			"If {C:attention}already #3#{}, convert to {C:attention}#4# Card",
			"If {C:attention}already #4#{}, apply {C:dark_edition}#5#",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 3, maxuses = 3, enhancement1 = "Wild", enhancement2 = "Gold", edition = "Negative"}},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_" .. string.lower(card.ability.extra.enhancement1)]
		info_queue[#info_queue+1] = G.P_CENTERS["m_" .. string.lower(card.ability.extra.enhancement2)]
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses,card.ability.extra.enhancement1,card.ability.extra.enhancement2,card.ability.extra.edition}}
    end,
	can_use = function(self,card)
		if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
			if 1 >= #G.hand.highlighted then
				return true
			end
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		local soundtable = {
			{
				sound = "roblr_RobloxSlingshot",
				pitch = 1,
				volume = 0.4,
			},
			{
				sound = "roblr_RobloxSlingshot",
				pitch = 1.2,
				volume = 0.4,
			},
			{
				sound = "negative",
				pitch = 1.5,
				volume = 0.4,
			},
		}
		SMODS.Gear.enhancers(self,card,area,copier,card.ability.extra.enhancement1,card.ability.extra.enhancement2,card.ability.extra.edition,soundtable)
	end,
}

SMODS.Gear{ --Superball
	key = "superball",
	pos = {
		x = 5,
		y = 0,
	},
	loc_txt = {
		name = "Superball",
		text = {
			"Apply a {C:attention}random Seal{} to a selected {C:attention}Card",
			"or {C:green}reroll{} a selected {C:attention}Consumable",
			"into one of the {C:attention}same type",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 3, maxuses = 3}},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses}}
    end,
	can_use = function(self,card)
		if #G.hand.highlighted + #G.consumeables.highlighted == 2 then
			return true
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
			if #G.hand.highlighted == 1 then
				--sealing card
				play_sound('roblr_RobloxSuperball', 1.2, 0.7)
                G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.2,
                    func = function()
						G.hand.highlighted[1]:set_seal(SMODS.poll_seal{
							type_key = "roblr_superball_seal",
							guaranteed = true,
						})
                        G.hand.highlighted[1]:juice_up(0.3, 0.4)
                        return true
                    end
                }))
			else
				--rerolling consumable
			local destroyed_consumable_index = 1
			for i, v in pairs (G.consumeables.highlighted) do
				if v ~= card then
					destroyed_consumable_index = i
				end
			end
			local card_set = G.consumeables.highlighted[destroyed_consumable_index].ability.set
			play_sound('roblr_RobloxSuperball', 1, 0.7)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.consumeables.highlighted[destroyed_consumable_index]:start_dissolve(nil, _first_dissolve)
					_first_dissolve = true
					local _card = SMODS.create_card({
						set = card_set,
						area = G.consumables,
						key_append = "roblr_superball",
					})
					_card:add_to_deck()
					G.consumeables:emplace(_card)
					_card:juice_up(0.3, 0.5)
                	card:juice_up(0.3, 0.5)
					return true
				end,
			}))
			end
	end,
}

SMODS.Gear{ --Boombox
	key = "boombox",
	pos = {
		x = 6,
		y = 0,
	},
	loc_txt = {
		name = "Boombox",
		text = {
			"In {C:attention}shop{}, reduce {C:attention}reroll{} cost by {C:money}$#3#",
			"for the rest of the shop",
			"During {C:attention}play{}, gain {C:money}$#4#",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 2, maxuses = 2, reroll_reduce = 3, money = 8}},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses,card.ability.extra.reroll_reduce,card.ability.extra.money}}
    end,
	can_use = function(self,card)
		if G.STATE == G.STATES.SELECTING_HAND or G.shop_jokers then
			return true
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		--reducing reroll cost
		if G.shop_jokers then
			play_sound('roblr_RainingTacos', 1, 0.3)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 2.4,
				timer = "REAL_SHADER", --ensures that the event is synced to the sound
				func = function()
					if G.GAME.round_resets.temp_reroll_cost then
						G.GAME.round_resets.temp_reroll_cost = math.max(G.GAME.round_resets.temp_reroll_cost - G.GAME.current_round.reroll_cost, G.GAME.round_resets.temp_reroll_cost - card.ability.extra.reroll_reduce)
					else
						G.GAME.round_resets.temp_reroll_cost = math.max(G.GAME.round_resets.reroll_cost - G.GAME.current_round.reroll_cost, G.GAME.round_resets.reroll_cost - card.ability.extra.reroll_reduce)
					end
					calculate_reroll_cost(true)
                	attention_text({
                    text = 'Reduced!',
                    	scale = 1.3, 
                    	hold = 1.4,
                    	major = card,
                    	backdrop_colour = G.C.MONEY,
                    	align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    	offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    	silent = true
                    })
					play_sound('tarot1')
                	card:juice_up(0.3, 0.5)
					return true
				end
			}))
		else
			--adding money
			play_sound('roblr_RainingTacos', 1, 0.3)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 2.4,
				timer = "REAL_SHADER",
				func = function()
					play_sound('timpani')
            		ease_dollars(card.ability.extra.money)
					attention_text({
							text = "+$" .. card.ability.extra.money,
							scale = 1.3, 
							hold = 1.4,
							major = card,
							backdrop_colour = G.C.MONEY,
							align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
							offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
							silent = true
						})
                	card:juice_up(0.3, 0.5)
					return true
				end
			}))
		end
	end,
}

SMODS.Gear{ --Paintball Gun
	key = "paintball_gun",
	pos = {
		x = 7,
		y = 0,
	},
	loc_txt = {
		name = "Paintball Gun",
		text = {
			"Convert {C:attention}3 random cards{} in hand",
			"to the {C:attention}suit{} of the selected card",
			"If card is {C:attention}Wild{}, make 2 {C:attention}Aces{} instead",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 2, maxuses = 2}},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses}}
    end,
	can_use = function(self,card)
		if #G.hand.highlighted == 1 then
			return true
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		local selected_card = G.hand.highlighted[1]
		--if wild, make them aces
		if selected_card.config.center_key == "m_wild" then
			--create a pool of valid cards and chosen cards
			local valid_cards = {}
			for i, v in pairs (G.hand.cards) do
				valid_cards[#valid_cards+1] = v
			end
			local chosen_cards = {}
			--omit the selected one
			for i, v in pairs (valid_cards) do
				if v == selected_card then
					valid_cards[i] = nil
				end
			end
			--choose 2 cards from that pool, add them to the chosen cards, and remove them from valid cards
			for i = 2, 1, -1 do
				local _card = pseudorandom_element(valid_cards, pseudoseed("roblr_paintball"))
				chosen_cards[#chosen_cards + 1] = _card
				for i, v in pairs (valid_cards) do
					if v == _card then
						valid_cards[i] = nil
					end
				end
			end
			--create an event for each card that changes the suit
			for i, v in pairs (chosen_cards) do
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.4,
					func = function()
						play_sound('roblr_PaintballGun', 1, 0.5)
						return true
					end,}))
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.05,
					func = function()
						SMODS.change_base(v,nil,"Ace")
						v:juice_up(0.3, 0.5)
						card:juice_up(0.2, 0.2)
						return true
					end,}))
			end
			--else change them to the same suit
		else
			--determine card suits
			local card_suit = nil
			local suit_list = {
				"Spades",
				"Hearts",
				"Clubs",
				"Diamonds"
			}
			for i, v in pairs (suit_list) do
				if selected_card:is_suit(v) then
					card_suit = v
				end
			end
			if not card_suit then
				card_suit = "Spades"
			end
			--create a pool of valid cards and chosen cards
			local valid_cards = {}
			for i, v in pairs (G.hand.cards) do
				valid_cards[#valid_cards+1] = v
			end
			local chosen_cards = {}
			--omit the selected one
			for i, v in pairs (valid_cards) do
				if v == selected_card then
					valid_cards[i] = nil
				end
			end
			--choose 3 cards from that pool, add them to the chosen cards, and remove them from valid cards
			for i = 3, 1, -1 do
				local _card = pseudorandom_element(valid_cards, pseudoseed("roblr_paintball"))
				chosen_cards[#chosen_cards + 1] = _card
				for i, v in pairs (valid_cards) do
					if v == _card then
						valid_cards[i] = nil
					end
				end
			end
			--create an event for each card that changes the suit
			for i, v in pairs (chosen_cards) do
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.4,
					func = function()
						play_sound('roblr_PaintballGun', 1, 0.3)
						return true
					end,}))
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.05,
					func = function()
						SMODS.change_base(v,card_suit)
						v:juice_up(0.3, 0.5)
						card:juice_up(0.2, 0.2)
						return true
					end,}))
			end
		end
	end,
}

SMODS.Gear{ --Gravity Coil
	key = "gravity_coil",
	pos = {
		x = 0,
		y = 1,
	},
	loc_txt = {
		name = "Gravity Coil",
		text = {
			"If selected hand is a {C:attention}Straight,",
			"{C:attention}Full House{}, or {C:attention}Five of a Kind",
			"make all cards the same random suit",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 3, maxuses = 3}},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses}}
    end,
	can_use = function(self,card)
		if G.hand.highlighted then
			if G.FUNCS.get_poker_hand_info(G.hand.highlighted) == 'Straight' or G.FUNCS.get_poker_hand_info(G.hand.highlighted) == 'Full House' or G.FUNCS.get_poker_hand_info(G.hand.highlighted) == 'Five of a Kind' then
				return true
			end
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		local suit_list = {
			"Spades",
			"Hearts",
			"Clubs",
			"Diamonds"
		}
		suit = pseudorandom_element(suit_list, pseudoseed("roblr_gravitycoil"))
		play_sound('roblr_RobloxGravityCoil', 1, 1)
        for i, v in ipairs (G.hand.highlighted) do
            G.E_MANAGER:add_event(Event({
				trigger = "after",
					delay = 0.4,
                func = function()
                    SMODS.change_base(v,suit)
                    v:juice_up(0.3, 0.4)
                    play_sound('roblr_RobloxButton', 1 + 0.1*i, 1)
                    return true
                end
            }))
        end
	end,
}

SMODS.Gear{ --Speed Coil
	key = "speed_coil",
	pos = {
		x = 1,
		y = 1,
	},
	loc_txt = {
		name = "Speed Coil",
		text = {
			"In {C:attention}shop{}, gain a Tag",
			"{C:attention}During play{}, gain #3# {C:attention}temporary {C:red}Discard",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 4, maxuses = 4, discards = 1}},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses,card.ability.extra.discards}}
    end,
	can_use = function(self,card)
		if G.STATE == G.STATES.SELECTING_HAND or G.shop_jokers then
			return true
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		--add tag
		if G.shop_jokers then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = (function()
					local tag = Tag(get_next_tag_key('speedcoil'))
					if tag.name == 'Boss Tag' or tag.name == 'Orbital Tag' then
						tag = tag_double
					end
					add_tag(tag)
					play_sound('roblr_RobloxSpeedCoil', 1, 0.5)
					return true
				end)
			}))
		else
			--temp discard
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = (function()
					ease_discard(card.ability.extra.discards)
					play_sound('roblr_RobloxSpeedCoil', 1, 0.5)
					return true
				end)
			}))
		end
	end,
}

SMODS.Gear{ --Ban Hammer
	key = "ban_hammer",
	pos = {
		x = 2,
		y = 1,
	},
	loc_txt = {
		name = "Ban Hammer",
		text = {
			"{C:red}Destroy{} a selected",
			"{C:attention}Joker{} to gain a",
			"random {C:money}Gear{} Card",
			"{C:inactive}#1#/#2# uses left",
			"{C:inactive}Must have room",
		}
	},
	config = {extra = {currentuses = 2, maxuses = 2}},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses}}
    end,
	can_use = function(self,card)
		if #G.jokers.highlighted == 1 then
			if not G.jokers.highlighted[1].ability.eternal then
				return true
			end
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		local joker = G.jokers.highlighted[1]
		--destroying
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				G.GAME.joker_buffer = G.GAME.joker_buffer - 1
				joker:start_dissolve({HEX("57ecab")}, nil, 1.6)
				play_sound('roblr_RobloxBanHammer', 1, 1)
				return true
			end,
		}))
		--creating the gear
		if not ((G.consumeables.config.card_limit - #G.consumeables.cards) < 1) then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function() 
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					local _card = SMODS.create_card({
						set = "gear",
						area = G.consumables,
						key_append = "roblr_ban",
					})
					_card:add_to_deck()
					G.consumeables:emplace(_card)
					_card:juice_up(0.3, 0.5)
					card:juice_up(0.3, 0.5)
					play_sound('tarot1', 1, 1)
					return true
				end,
			}))
		end
	end,
}

SMODS.Gear{ --Zombie Staff
	key = "zombie_staff",
	pos = {
		x = 3,
		y = 1,
	},
	loc_txt = {
		name = "Zombie Staff",
		text = {
			"In {C:attention}shop, create #3#",
			"{C:dark_edition}Negative{} {C:purple}Tarot{} Cards",
			"{C:attention}During play{}, create a",
			"{C:dark_edition}Negative{} {C:attention}Common Joker",
			"{C:inactive}#1#/#2# uses left",
		}
	},
	config = {extra = {currentuses = 2, maxuses = 2, tarots = 2}},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.currentuses,card.ability.extra.maxuses,card.ability.extra.tarots}}
    end,
	can_use = function(self,card)
		if G.STATE == G.STATES.SELECTING_HAND or G.shop_jokers then
			return true
		end
	end,
	use = function(self,card,area,copier)
		SMODS.Gear.use(self, card, area, copier)
		local summoned_cards = {}
		--create tarots
		if G.shop_jokers then
			for i = card.ability.extra.tarots, 1, -1 do
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.4,
					func = (function()
						local _card = SMODS.create_card({
							set = "Tarot",
							area = G.consumables,
							key_append = "roblr_zombie",
						})
            	        _card:add_to_deck()
            	        G.consumeables:emplace(_card)
            	        G.GAME.consumeable_buffer = 0
            	        _card:set_edition({negative = true},true)
						summoned_cards[#summoned_cards + 1] = _card
						return true
					end)
				}))
			end
			--cosmetic stuff
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.8,
				func = (function()
					card:juice_up(0.5,0.8)
					for i, v in pairs (summoned_cards) do
						v:juice_up(0.8,0.3)
					end
					play_sound('roblr_ZombieGroan',1, 1)
					attention_text({
						text = "RISEN",
						scale = 1.3, 
						hold = 1.4,
						major = card,
						backdrop_colour = G.C.PURPLE,
						align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
						offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
						silent = true
					})
					return true
				end)
			}))
		else
			--add joker
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = (function()
					local _card = SMODS.create_card({
						set = "Joker",
						area = G.jokers,
						key_append = "roblr_zombie_jokers",
						rarity = 0,
					})
                    _card:add_to_deck()
                    G.jokers:emplace(_card)
                    G.GAME.joker_buffer = 0
                    _card:set_edition({negative = true},true)
                    card:juice_up(0.5,0.5)
					summoned_cards[#summoned_cards + 1] = _card
					return true
				end)
			}))
			--cosmetic stuff
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.8,
				func = (function()
					card:juice_up(0.5,0.5)
					play_sound('roblr_ZombieGroan',1, 1)
					for i, v in pairs (summoned_cards) do
						v:juice_up(0.8,0.3)
					end
					attention_text({
						text = "RISEN",
						scale = 1.3, 
						hold = 1.4,
						major = card,
						backdrop_colour = G.C.PURPLE,
						align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
						offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
						silent = true
					})
					return true
				end)
			}))
		end
	end,
}