--- STEAMODDED HEADER
--- MOD_NAME: Azazel's Jokers
--- MOD_ID: AzzysJokers
--- MOD_AUTHOR: [Starlet Devil]
--- MOD_DESCRIPTION: Adds a crew of new Jokers I thought of
--- VERSION: 1.0.0
--- PREFIX: azzy
----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas {
	key = "jokers",
	path = "mainatlas.png",
	px = 71,
	py = 95
}

SMODS.Joker {
	key = 'arcade',
	loc_txt = {
		name = 'Arcade',
		text = {
			"At {C:attention}end of round{}, earn {C:money}$2{}",
			"for each time most played",
			"{C:attention}poker hand{} was played"
		}
	},
	config = { extra = { handScore = 0 } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 4, y = 3 },
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.handScore } }
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind then
			card.ability.extra.handScore = 0
		elseif context.before and G.GAME.current_round.most_played_poker_hand then
			--print("this is a test")
			if context.scoring_name == G.GAME.current_round.most_played_poker_hand then
				--print("add handscore")
				card.ability.extra.handScore = card.ability.extra.handScore + 1
			end
		end
	end,
	
	calc_dollar_bonus = function(self, card)
		--print(card.ability.extra.handScore)
		local bonus = card.ability.extra.handScore * 2
		if bonus > 0 then
			return bonus
		end
	end
}

SMODS.Joker {
	key = 'birthdaycake',
	loc_txt = {
		name = 'Birthday Cake',
		text = {
			"Earn {C:money}$#1#{} when {C:attention}Boss Blind{} is",
			"defeated, decreases by",
			"{C:money}$2{} each payout"
		}
	},
	config = { extra = { payout = 10, oldpayout = 10, canPay = true } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 5, y = 2 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.payout, card.ability.extra.oldpayout, card.ability.extra.canPay } }
	end,
	
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and card.ability.extra.canPay then
			if G.GAME.last_blind and G.GAME.last_blind.boss then
				ease_dollars(card.ability.extra.payout)
				card.ability.extra.payout = card.ability.extra.payout - 2
				card.ability.extra.canPay = false
				if card.ability.extra.payout == 0 then
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound('tarot1')
							card.T.r = -0.2
							card:juice_up(0.3, 0.4)
							card.states.drag.is = true
							card.children.center.pinch.x = true
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.3,
								blockable = false,
								func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
									return true;
								end
							}))
							return true
						end
					}))
					return {
						message = 'Eaten!'
					}
				else
					return {
						message = 'Allowance!',
						colour = G.C.MONEY
					}
				end
			end
		elseif context.setting_blind then
			card.ability.extra.canPay = true
		end
	end
}

SMODS.Joker {
	key = 'caboose',
	loc_txt = {
		name = 'Caboose',
		text = {
			"Retriggers {C:attention}last{} played card",
			"{C:attention}2{} additional times"
		}
	},
	config = { extra = { repetitions = 2 } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 3, y = 2 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			if (context.other_card == context.scoring_hand[#context.scoring_hand]) then
				return {
					message = localize('k_again_ex'),
					repetitions = card.ability.extra.repetitions
				}
			end
        end
	end
}

SMODS.Joker {
	key = 'dartboard',
	loc_txt = {
		name = 'Dartboard',
		text = {
			"Retriggers {C:attention}middle{} played card",
			"{C:attention}2{} additional times",
			"{s:0.8}Can only activate on odd hand sizes{}"
		}
	},
	config = { extra = { repetitions = 2 } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 2, y = 2 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			if #context.scoring_hand == 1 then
				if (context.other_card == context.scoring_hand[1]) then
					return {
						message = localize('k_again_ex'),
						repetitions = card.ability.extra.repetitions
					}
				end
			elseif #context.scoring_hand == 3 then
				if (context.other_card == context.scoring_hand[2]) then
					return {
						message = localize('k_again_ex'),
						repetitions = card.ability.extra.repetitions
					}
				end
			elseif #context.scoring_hand == 5 then
				if (context.other_card == context.scoring_hand[3]) then
					return {
						message = localize('k_again_ex'),
						repetitions = card.ability.extra.repetitions
					}
				end
			end
        end
	end
}

SMODS.Joker {
	key = 'fortunecookie',
	loc_txt = {
		name = 'Fortune Cookie',
		text = {
			"Gains {C:chips}+2{} Chips for each {C:attention}7{} played,",
			"every {C:chips}30{} Chips gained increases {C:attention}sell",
			"{C:attention}value{} by {C:money}$6{}, doubles payout at {C:money}$90{}",
			"{C:inactive}(Currently {C:chips}+#1#{} {C:inactive}Chips) [#2#]{}"
		}
	},
	config = { extra = { chipHold = 0, chipCount = 0 } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 1, y = 2 },
	cost = 3,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chipHold, card.ability.extra.chipCount } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 7 and not context.blueprint then
				card.ability.extra.chipHold = card.ability.extra.chipHold + 2
				card.ability.extra.chipCount = card.ability.extra.chipCount + 2
				if card.ability.extra.chipCount >= 30 and not context.blueprint then
					card.ability.extra_value = card.ability.extra_value + 6
					card:set_cost()
					card.ability.extra.chipCount = 0
					return {
						message = localize('k_val_up'),
						colour = G.C.MONEY
					}
				else
					return {
						message = localize('k_upgrade_ex'),
						colour = G.C.CHIPS
					}
				end
			end
			
		elseif context.joker_main then 
			return {
				chips = card.ability.extra.chipHold
			}
		elseif context.end_of_round and context.cardarea == G.jokers then
			if card.ability.extra_value >= 90 then
				ease_dollars(card.ability.extra_value * 2)
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = 'Eaten!'
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'legion',
	loc_txt = {
		name = 'Legion',
		text = {
			"Each scored card with a ",
			"{C:attention}matching suit{} scores {C:chips}+44{} Chips,",
			"each scored card with a",
			"{C:attention}matching rank{} scores {C:mult}+4{} Mult"
		}
	},
	config = { extra = { chipScore = 0, multScore = 0 } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 3, y = 3 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chipScore, card.ability.extra.multScore } }
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			card.ability.extra.chipScore = 0
			card.ability.extra.multScore = 0
			for i=1, #context.full_hand do
				if context.full_hand[i] ~= context.other_card and not context.full_hand[i].debuff then
					if context.full_hand[i].base.value == context.other_card.base.value then
						card.ability.extra.multScore = 1
					end
					if context.full_hand[i].base.suit == context.other_card.base.suit then
						card.ability.extra.chipScore = 1
					end
				end
			end
			return {
				chips = card.ability.extra.chipScore * 44,
				mult = card.ability.extra.multScore * 4
			}
		end
	end
}

SMODS.Joker {
	key = 'quarternote',
	loc_txt = {
		name = 'Quarter Note',
		text = {
			"Each scored {C:attention}4{} adds {C:mult}+4{} Mult",
			"for every {C:attention}4{} in the scored hand"
		}
	},
	config = { extra = { fourscore = 0 } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 0, y = 2 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.fourscore } }
	end,
	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then
			card.ability.extra.fourscore = 0
			for i=1, #context.full_hand do
				if context.full_hand[i]:get_id() == 4 then
					card.ability.extra.fourscore = card.ability.extra.fourscore + 4
				end
			end
		elseif context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 4 then
				return {
					mult = card.ability.extra.fourscore
				}
			end
		end
	end
}

SMODS.Joker{
	key = 'revolver',
	loc_txt = {
		name = "Revolver",
		text = {
			"Every {C:attention}sixth{} card scored",
			"gives {X:mult,C:white} X#1# {} Mult {C:inactive}[#2#]{}"
		}
	},
	rarity = 1,
	discovered = true,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 0 },
	config = { extra = { Xmult = 2, cardTrack = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.cardTrack } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then 
			if card.ability.extra.cardTrack == 6 then
				if not context.blueprint then
					card.ability.extra.cardTrack = 1
				end
				return {
					x_mult = card.ability.extra.Xmult,
					--card = self
				}
			else 
				if not context.blueprint then
					card.ability.extra.cardTrack = card.ability.extra.cardTrack + 1
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'siren',
	loc_txt = {
		name = 'Siren',
		text = {
			"Earn an extra {C:money}$2{} per",
			"each {C:attention}remaining hand{}"
		}
	},
	config = { extra = { handbonus = 0 } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 6, y = 2 },
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.handbonus } }
	end,
	
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers then
			card.ability.extra.handbonus = G.GAME.current_round.hands_left * 2
        end
	end,
	
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.handbonus
		if bonus > 0 then return bonus end
	end
}

SMODS.Joker{
	key = 'warmachine',
	loc_txt = {
		name = "War Machine",
		text = {
			"Played {C:attention}Stone or Steel Cards{}",
			"give {C:mult}+9{} Mult when scored"
		}
	},
	rarity = 1,
	discovered = true,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 0 },
	config = { extra = { multWM = 9 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.multWM } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then 
			if context.other_card.config.center_key == 'm_stone' or context.other_card.config.center_key == 'm_steel' then
				return {
					mult = 9
					--mult = card.ability.extra.multWM,
					--card = self
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'amanojaku',
	loc_txt = {
		name = "Amanojaku",
		text = {
			"When {C:attention}Blind{} is selected, reduce",
			"{C:attention}highest{} hand level by {C:attention}1{} and",
			"increase {C:attention}lowest{} hand level by {C:attention}2{}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 7,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 1 },
	config = { extra = { canLevelHand = false, highestLevel = 999, lowestLevel = 1, validLevel = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.canLevelHand, card.ability.extra.highestLevel, card.ability.extra.lowestLevel, card.ability.extra.validLevel } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			local _handname, _levels, _order = 'High Card', card.ability.extra.lowestLevel, 100
			
			for k, v in pairs(G.GAME.hands) do
				if (v.level > _levels or (v.played == _levels and _order > v.order)) and v.visible == true then 
					_levels = v.level
					_handname = k
					card.ability.extra.highestLevel = G.GAME.hands[_handname].level
				end
			end
			
			
			
			local _handname2, _levels2, _order2 = 'High Card', card.ability.extra.highestLevel, 100
			
			for k, v in pairs(G.GAME.hands) do
				if (v.level < _levels2 or (v.played == _levels2 and _order > v.order)) and v.visible == true then 
					_levels2 = v.level
					_handname2 = k
					card.ability.extra.lowestLevel = G.GAME.hands[_handname2].level
				end
			end
			
			local validHands = {}
				
			for s, t in pairs(G.GAME.hands) do
				if (t.level == card.ability.extra.lowestLevel) and t.visible == true then 
					table.insert(validHands, s)
				end
			end
			
			if validHands[1] ~= nil and G.GAME.hands[_handname].level > 1 then
				--local text,disp_text = G.FUNCS.get_poker_hand_info(_handname)
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reversal!"})
				update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_handname, 'poker_hands'),chips = G.GAME.hands[_handname].chips, mult = G.GAME.hands[_handname].mult, level=G.GAME.hands[_handname].level})
				level_up_hand(card, _handname, nil, -1)
				update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
					
				local handToLevel = pseudorandom_element(validHands, pseudoseed('amanojaku'))
				update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(handToLevel, 'poker_hands'),chips = G.GAME.hands[handToLevel].chips, mult = G.GAME.hands[handToLevel].mult, level=G.GAME.hands[handToLevel].level})
				level_up_hand(card, handToLevel, nil, 2)
				update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
			end
		end
	end
}

SMODS.Joker {
	key = 'avantgarde',
	loc_txt = {
		name = 'Avant-Garde',
		text = {
			"Gains {X:mult,C:white}X#2#{} Mult for",
			"each {C:attention}unique suit{} scored,",
			"resets every hand"
		}
	},
	config = { extra = { Xmult = 1, XmultGain = 0.75 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 6, y = 1 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.XmultGain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local suits = {
				['Hearts'] = 0,
				['Diamonds'] = 0,
				['Spades'] = 0,
				['Clubs'] = 0
			}
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].ability.name ~= 'Wild Card' then
					if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then 
						suits["Hearts"] = suits["Hearts"] + 1
						card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.XmultGain
					elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0  then 
						suits["Diamonds"] = suits["Diamonds"] + 1
						card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.XmultGain
					elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then 
						suits["Spades"] = suits["Spades"] + 1
						card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.XmultGain
					elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0  then 
						suits["Clubs"] = suits["Clubs"] + 1
						card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.XmultGain
					end
				end
			end
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].ability.name == 'Wild Card' then
					if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then 
						suits["Hearts"] = suits["Hearts"] + 1
						card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.XmultGain
					elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0  then 
						suits["Diamonds"] = suits["Diamonds"] + 1
						card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.XmultGain
					elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then 
						suits["Spades"] = suits["Spades"] + 1
						card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.XmultGain
					elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0  then 
						suits["Clubs"] = suits["Clubs"] + 1
						card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.XmultGain
					end
				end
			end
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
				Xmult_mod = card.ability.extra.Xmult
			}
		elseif context.after and context.cardarea == G.jokers then
			card.ability.extra.Xmult = 1
			return {
				message = localize('k_reset')
			}
		end
	end
}

SMODS.Joker {
	key = 'bakeneko',
	loc_txt = {
		name = 'Bakeneko',
		text = {
			"{X:mult,C:white}X#1#{} Mult if any {C:attention}2{} scored",
			"cards are {C:attention}identical{}"
		}
	},
	config = { extra = { xmult = 2, cardCheck = false } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 9, y = 2 },
	soul_pos = { x = 0, y = 3 },
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.cardCheck } }
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			card.ability.extra.cardCheck = false
			for i=1, #context.full_hand do
				if context.full_hand[i] ~= context.other_card then
					if context.full_hand[i].base.value == context.other_card.base.value then
						if context.full_hand[i].base.suit == context.other_card.base.suit then
							if context.full_hand[i].seal == context.other_card.seal then
								if context.full_hand[i].config.center_key == context.other_card.config.center_key then
									if (context.full_hand[i].edition and context.full_hand[i].edition.holo) and (context.other_card.edition and context.other_card.edition.holo) then
										card.ability.extra.cardCheck = true
									elseif (context.full_hand[i].edition and context.full_hand[i].edition.foil) and (context.other_card.edition and context.other_card.edition.foil) then
										card.ability.extra.cardCheck = true
									elseif (context.full_hand[i].edition and context.full_hand[i].edition.polychrome) and (context.other_card.edition and context.other_card.edition.polychrome) then
										card.ability.extra.cardCheck = true
									elseif (context.full_hand[i].edition and context.full_hand[i].edition.negative) and (context.other_card.edition and context.other_card.edition.negative) then
										card.ability.extra.cardCheck = true
									elseif not context.full_hand[i].edition and not context.other_card.edition then
										card.ability.extra.cardCheck = true
									end
								end
							end
						end
					end
				end
			end
		elseif context.joker_main and card.ability.extra.cardCheck then 
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
				Xmult_mod = card.ability.extra.xmult
			}
		end
	end,

}

SMODS.Joker{
	key = 'cerebral',
	loc_txt = {
		name = "Cerebral",
		text = {
			"Swaps base {C:chips}Chips{} and {C:mult}Mult{}",
			"of poker hands {C:attention}before scoring{}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 0 },
	config = { extra = { chipStorage = 0, multStorage = 0, swapMessage = "Swapped!", hasSwapped = false } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chipStorage, card.ability.extra.multStorage, card.ability.extra.swapMessage } }
	end,
	calculate = function(self, card, context)
		if context.after_before and not context.blueprint then
			return {
				swap = true,
				message = "Swapped!",
				colour = G.C.PURPLE
				--message = localize{type = 'variable', key = 'a_mult', vars = { card.ability.extra.swapMessage } }
			}
		end
	end
}

SMODS.Joker{
	key = 'homunculus',
	loc_txt = {
		name = "Homunculus",
		text = {
			"Scored cards additionally score",
			"{C:attention}half{} their {C:chips}Chips{} value in {C:mult}Mult{}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 0 },
	config = { extra = { homvalue = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.homvalue } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then 
			return {
				mult = context.other_card:get_chip_bonus() / 2
			}
		end
	end
}

SMODS.Joker {
	key = 'mothman',
	loc_txt = {
		name = 'Mothman',
		text = {
			"If the {C:attention}#2#{} of {C:diamonds}Diamonds{} is",
			"scored on the {C:attention}last{} hand of the",
			"{C:attention}round{}, creates a {C:spectral}Cryptid{} card",
			"{s:0.8}Rank changes every round",
			"{C:inactive}(Must have room){}"
		}
	},
	config = { extra = { targetid = 14, targetvalue = 'Ace', hasActivated = false } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 4, y = 1 },
	soul_pos = { x = 5, y = 1 },
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.targetid, card.ability.extra.targetvalue, card.ability.extra.hasActivated } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers then
			card.ability.extra.hasActivated = false
			targetid = 14
			targetvalue = "Ace"
			local valid_moth_cards = {}
			for k, v in ipairs(G.playing_cards) do
				if not SMODS.has_no_suit(v) and v:is_suit('Diamonds') then
					valid_moth_cards[#valid_moth_cards+1] = v
				end
			end
			if valid_moth_cards[1] then 
				local moth_card = pseudorandom_element(valid_moth_cards, pseudoseed('mothman'..G.GAME.round_resets.ante))
				card.ability.extra.targetvalue = moth_card.base.value
				card.ability.extra.targetid = moth_card.base.id
			end
		elseif context.individual and context.cardarea == G.play and not context.blueprint and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			if card.ability.extra.hasActivated ~= true and G.GAME.current_round.hands_left == 0 then
				if context.other_card:get_id() == card.ability.extra.targetid and context.other_card:is_suit('Diamonds') then
					return {
						extra = {focus = card, message = "Sighting!", func = function()
							card.ability.extra.hasActivated = true
							G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
							--card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Sighting!"})
							G.E_MANAGER:add_event(Event({
								trigger = 'before',
								delay = 0.0,
								func = (function()
									SMODS.add_card{key = "c_cryptid"}
									G.GAME.consumeable_buffer = 0
									return true
							end)}))
						end},
						colour = G.C.YELLOW
					}
				end
			else
				return
			end
		end
	end
}

SMODS.Joker{
	key = 'ouroborous',
	loc_txt = {
		name = "Ouroboros",
		text = {
			"When a {C:attention}Glass Card{} shatters,",
			"create a new one with a",
			"random {C:attention}rank{} and {C:attention}suit{}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 9, y = 0 },
	enhancement_gate = 'm_glass',
	config = { extra = {  } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards then
			local glass_cards = 0
			for k, val in ipairs(context.removed) do
				if val.shattered then glass_cards = glass_cards + 1 end
			end
			if glass_cards > 0 then
				for i = 1, glass_cards
				do
					G.E_MANAGER:add_event(Event({
						func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								local front = pseudorandom_element(G.P_CARDS, pseudoseed('ouroborous'))
								G.playing_card = (G.playing_card and G.playing_card + 1) or 1
								local _card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_glass, {playing_card = G.playing_card})
								_card:start_materialize({G.C.SECONDARY_SET.Enhanced})
								G.play:emplace(_card)
								table.insert(G.playing_cards, _card)
								return true
								end
						}))
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Renewal!"})
						G.E_MANAGER:add_event(Event({
							func = function() 
								G.deck.config.card_limit = G.deck.config.card_limit + 1
								return true
							end}))
							draw_card(G.play,G.deck, 90,'up', nil)  

						playing_card_joker_effects({true})
						return true
						end
					}))
					glass_cards = glass_cards - 1
				end
			end
		end
		
	end
}

SMODS.Joker{
	key = 'princess',
	loc_txt = {
		name = "Princess",
		text = {
			"Gains {C:mult}+1{} Mult for",
			"each face card scored",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 0, y = 0 },
	config = { extra = { mult_add = 1, pool = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_add, card.ability.extra.pool } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not SMODS.has_no_rank(context.other_card) and not context.blueprint then
			if context.other_card:is_face() then
				card.ability.extra.pool = card.ability.extra.pool + card.ability.extra.mult_add
				--card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MULT
				}
			end
		elseif context.joker_main then
			return {
				message = localize { type = "variable", key = "a_mult", vars = { card.ability.extra.pool } },
				mult_mod = card.ability.extra.pool
			}
		end
	end
}

SMODS.Joker {
	key = 'spellbook',
	loc_txt = {
		name = 'Spellbook',
		text = {
			"When using a {C:planet}Planet{}, {C:tarot}Tarot{}, or",
			"{C:spectral}Spectral{} card, has a {C:green}#3# in #2#{}",
			"chance to {C:attention}create{} a random one",
			"that was {C:attention}previously used{}"
		}
	},
	config = { extra = { usedConsumes = {}, odds = 3 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 8, y = 2 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.usedConsumes, card.ability.extra.odds, (G.GAME.probabilities.normal or 1) } }
	end,
	
	calculate = function(self, card, context)
		if context.using_consumeable then
			local consumeCheck = 0
			for i = 1, #card.ability.extra.usedConsumes do
				if context.consumeable.config.center.key == card.ability.extra.usedConsumes[i] then
					consumeCheck = 1
				end
			end
			if consumeCheck == 0 then
				table.insert(card.ability.extra.usedConsumes, context.consumeable.config.center.key)
			end
			if card.ability.extra.usedConsumes[1] then
				
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.2,
					func = (function()
						if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
							G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
							if pseudorandom("spellbook") < G.GAME.probabilities.normal / card.ability.extra.odds then
								card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Recalled', colour = G.C.BLUE})
								SMODS.add_card{key = pseudorandom_element(card.ability.extra.usedConsumes, pseudoseed("spellbook"))}
								G.GAME.consumeable_buffer = 0
								return true
							else
								G.GAME.consumeable_buffer = 0
								return true
							end
						else
							G.GAME.consumeable_buffer = 0
							return true
						end
				end)}))
			end
		end
	end
}

SMODS.Joker {
	key = 'twofaced',
	loc_txt = {
		name = 'Two-Faced',
		text = {
			"{X:mult,C:white}X#1#{} Mult if all cards in",
			"{C:attention}scored hand{} include and are ",
			"exclusively {C:hearts}Hearts{} and {C:spades}Spades{}"
		}
	},
	config = { extra = { Xmult = 2 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 9, y = 1 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local suits = {
				['Hearts'] = 0,
				['Diamonds'] = 0,
				['Spades'] = 0,
				['Clubs'] = 0
			}
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].ability.name ~= 'Wild Card' then
					if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then 
						suits["Hearts"] = suits["Hearts"] + 1
					elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0  then 
						suits["Diamonds"] = suits["Diamonds"] + 1
					elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then 
						suits["Spades"] = suits["Spades"] + 1
					elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0  then 
						suits["Clubs"] = suits["Clubs"] + 1
					end
				end
			end
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].ability.name == 'Wild Card' then
					if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then 
						suits["Hearts"] = suits["Hearts"] + 1
					elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then 
						suits["Spades"] = suits["Spades"] + 1
					end
				end
			end
			if suits["Hearts"] > 0 and suits["Diamonds"] == 0 and suits["Spades"] > 0 and suits["Clubs"] == 0 then
				return {
					message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
					Xmult_mod = card.ability.extra.Xmult
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'doublebarrel',
	loc_txt = {
		name = "Double Barrel",
		text = {
			"Every {C:attention}second{} card scored",
			"gives {X:mult,C:white} X#1# {} Mult, this has a",
			"{C:green}#5# in #3#{} chance to {C:red}backfire{},",
			"giving {X:mult,C:white}X#4#{} Mult instead {C:inactive}[#2#]{}"
		}
	},
	rarity = 3,
	discovered = true,
	cost = 9,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 1 },
	config = { extra = { Xmult = 2, cardTrack = 1, backfireOdds = 200, backfireMult = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.cardTrack, card.ability.extra.backfireOdds, card.ability.extra.backfireMult, (G.GAME.probabilities.normal or 1) } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then 
			if card.ability.extra.cardTrack == 2 then
				if not context.blueprint then
					card.ability.extra.cardTrack = 1
				end
				local randoBrain = pseudorandom('doublebarrel')
				if not context.blueprint then
					if randoBrain < G.GAME.probabilities.normal / card.ability.extra.backfireOdds then
						return {
							message = "Backfire!",
							colour = G.C.RED,
							x_mult = card.ability.extra.backfireMult,
							--card = self
						}
					else
						return {
					
							x_mult = card.ability.extra.Xmult,
							--card = self
						}
					end
				else
					return {
					
						x_mult = card.ability.extra.Xmult,
						--card = self
					}
				end
			else 
				if not context.blueprint then
					card.ability.extra.cardTrack = card.ability.extra.cardTrack + 1
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'housewitch',
	loc_txt = {
		name = 'Housewitch',
		text = {
			"Retrigger cards with",
			"{C:attention}seals{} on them"
		}
	},
	config = { extra = { repetitions = 1 } },
	rarity = 3,
	atlas = 'jokers',
	pos = { x = 7, y = 2 },
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions } }
	end,
	
	calculate = function(self, card, context)
		--Red and Gold Seals
		if context.cardarea == G.play and context.repetition then
			if context.other_card.seal == "Red" or context.other_card.seal == "Gold" then 
				return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		--Blue Seals
        elseif context.cardarea == G.hand and context.repetition then
			if (context.other_card.seal == "Red" and (context.other_card.config.center_key == "m_steel" or context.other_card.config.center_key == "m_gold")) or (context.other_card.seal == "Blue" and context.end_of_round) then 
				return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		--Purple Seals
		elseif context.discard then
			if (context.other_card.seal == "Purple") and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then 
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
						local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'housewitch')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
					return true
				end)}))
				card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
			end
		end
	end
}

SMODS.Joker{
	key = 'jadedragon',
	loc_txt = {
		name = "Jade Dragon",
		text = {
			"All {C:green}listed probabilities{}",
			"are increased by {C:attention}2{}",
			"{C:inactive}(ex:{C:green} 1 in 2 {}{C:inactive}->{C:green} 3 in 2 {}{C:inactive})"
		}
	},
	rarity = 3,
	discovered = true,
	cost = 9,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 0 },
	config = { extra = {  } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	add_to_deck = function(self, card, from_debuff)
		for k, v in pairs(G.GAME.probabilities) do 
                G.GAME.probabilities[k] = v + 2
				G.GAME.probabilities[k] = math.ceil(G.GAME.probabilities[k])
        end
	end,
	remove_from_deck = function(self, card, from_debuff)
		for k, v in pairs(G.GAME.probabilities) do 
                G.GAME.probabilities[k] = v - 2
				G.GAME.probabilities[k] = math.ceil(G.GAME.probabilities[k])
        end
	end
}

SMODS.Joker {
	key = 'overmind',
	loc_txt = {
		name = 'Overmind',
		text = {
			"Displays {C:attention}top 5 cards{} in",
			"your deck when in play",
			"{C:inactive}[{C:red}#1#{C:inactive}], {C:inactive}[{C:red}#2#{C:inactive}]",
			"{C:inactive}[{C:red}#3#{C:inactive}], {C:inactive}[{C:red}#4#{C:inactive}]",
			"{C:inactive}[{C:red}#5#{C:inactive}]",
		}
	},
	config = { 
		extra = {
			card1ID = "",--(G.deck and G.deck.cards[#G.deck.cards].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards].base.suit or 'Hearts'), 
			card2ID = "",--(G.deck and G.deck.cards[#G.deck.cards - 1].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 1].base.suit or 'Hearts'), 
			card3ID = "",--(G.deck and G.deck.cards[#G.deck.cards - 2].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 2].base.suit or 'Hearts'), 
			card4ID = "",--(G.deck and G.deck.cards[#G.deck.cards - 3].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 3].base.suit or 'Hearts'), 
			card5ID = "",--(G.deck and G.deck.cards[#G.deck.cards - 4].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 4].base.suit or 'Hearts') 
			obfuscateCards = true
		} 
	},
	rarity = 3,
	atlas = 'jokers',
	pos = { x = 4, y = 2 },
	cost = 9,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.card1ID, card.ability.extra.card2ID, card.ability.extra.card3ID, card.ability.extra.card4ID, card.ability.extra.card5ID, card.ability.extra.obfuscateCards } }
	end,
	
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.obfuscateCards = false
	end,
	-- Inverse of above function.
	remove_from_deck = function(self, card, from_debuff)
		card.ability.extra.obfuscateCards = true
	end,
	
	update = function(self, card, dt) 
		if not card.ability.extra.obfuscateCards then
			card.ability.extra.card1ID = (G.deck and G.deck.cards[#G.deck.cards] and G.deck.cards[#G.deck.cards].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards] and G.deck.cards[#G.deck.cards].base.suit or 'Hearts') 
			card.ability.extra.card2ID = (G.deck and G.deck.cards[#G.deck.cards - 1] and G.deck.cards[#G.deck.cards - 1].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 1] and G.deck.cards[#G.deck.cards - 1].base.suit or 'Hearts')
			card.ability.extra.card3ID = (G.deck and G.deck.cards[#G.deck.cards - 2] and G.deck.cards[#G.deck.cards - 2].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 2] and G.deck.cards[#G.deck.cards - 2].base.suit or 'Hearts')
			card.ability.extra.card4ID = (G.deck and G.deck.cards[#G.deck.cards - 3] and G.deck.cards[#G.deck.cards - 3].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 3] and G.deck.cards[#G.deck.cards - 3].base.suit or 'Hearts')
			card.ability.extra.card5ID = (G.deck and G.deck.cards[#G.deck.cards - 4] and G.deck.cards[#G.deck.cards - 4].base.value or "Ace")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 4] and G.deck.cards[#G.deck.cards - 4].base.suit or 'Hearts') 
		else
			card.ability.extra.card1ID = "NULL"
			card.ability.extra.card2ID = "VOID"
			card.ability.extra.card3ID = "ABYS"
			card.ability.extra.card4ID = "BLNK"
			card.ability.extra.card5ID = "APEIRON"
		end
	end
}

SMODS.Joker {
	key = 'punchcard',
	loc_txt = {
		name = 'Punch Card',
		text = {
			"Gains {X:mult,C:white} X#2# {} Mult each time",
			"a card is {C:attention}retriggered{}",
			"{C:inactive}(Currently {}{X:mult,C:white}X#1#{} {C:inactive}Mult){}"
		}
	},
	config = { extra = { Xmult = 1, XmultGain = 0.1 } },
	rarity = 3,
	atlas = 'jokers',
	pos = { x = 1, y = 1 },
	cost = 9,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.XmultGain } }
	end,
	calculate = function(self, card, context)
	
		if (context.cardarea == G.play or context.cardarea == G.hand) and context.individual and not context.blueprint then
			if card.ability.extra.last_card and context.other_card == card.ability.extra.last_card then
				card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.XmultGain
				return {
					message = localize("k_upgrade_ex"),
					message_card = card
				}
			else
				card.ability.extra.last_card = context.other_card
			end
		elseif context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
		end
	end
	
}

SMODS.Joker {
	key = 'recitation',
	loc_txt = {
		name = 'Recitation',
		text = {
			"Create a random {C:planet}Planet{} or",
			"{C:tarot}Tarot{} card if poker hand",
			"is a {C:attention}Straight{} {C:red}or{} {C:attention}Flush{}"
		}
	},
	config = { extra = { planetOdds = 5, tarotOdds = 10, specOdds = 10 } },
	rarity = 3,
	atlas = 'jokers',
	pos = { x = 2, y = 1 },
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.planetOdds, card.ability.extra.tarotOdds, card.ability.extra.specOdds, (G.GAME.probabilities.normal or 1) } }
	end,
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Flush']) and not context.blueprint then
			local cardType = ''
			
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
						local randoBrain = pseudorandom('recite')
						-- if randoBrain <= G.GAME.probabilities.normal / card.ability.extra.specOdds then
							-- SMODS.add_card{set = 'Spectral' , key_append = 'recite'}
						-- elseif randoBrain <= G.GAME.probabilities.normal / card.ability.extra.tarotOdds then
							-- SMODS.add_card{set = 'Tarot' , key_append = 'recite'}
						if randoBrain <= G.GAME.probabilities.normal / card.ability.extra.planetOdds then
							SMODS.add_card{set = 'Planet' , key_append = 'recite'}
						else 
							SMODS.add_card{set = 'Tarot' , key_append = 'recite'}
						end
						
						--local _card = create_card(cardType,G.consumeables, nil, nil, nil, nil, nil, 'recite')
						--_card:add_to_deck()
						--G.consumeables:emplace(_card)
						G.GAME.consumeable_buffer = 0
						return true
				end)}))
				return {
					
					message = "Summoned",
					colour = G.C.RED
				}
			end
		elseif context.before and next(context.poker_hands['Straight']) and not context.blueprint then
			local cardType = ''
			
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
						local randoBrain = pseudorandom('recite')
						-- if randoBrain <= G.GAME.probabilities.normal / card.ability.extra.specOdds then
							-- SMODS.add_card{set = 'Spectral' , key_append = 'recite'}
						-- elseif randoBrain <= G.GAME.probabilities.normal / card.ability.extra.tarotOdds then
							-- SMODS.add_card{set = 'Tarot' , key_append = 'recite'}
						if randoBrain <= G.GAME.probabilities.normal / card.ability.extra.planetOdds then
							SMODS.add_card{set = 'Planet' , key_append = 'recite'}
						else 
							SMODS.add_card{set = 'Tarot' , key_append = 'recite'}
						end
						
						--local _card = create_card(cardType,G.consumeables, nil, nil, nil, nil, nil, 'recite')
						--_card:add_to_deck()
						--G.consumeables:emplace(_card)
						G.GAME.consumeable_buffer = 0
						return true
				end)}))
				return {
					
					message = "Summoned",
					colour = G.C.RED
				}
			end
		end
	end
}

SMODS.Joker{
	key = 'spotlight',
	loc_txt = {
		name = "Spotlight",
		text = {
			"{C:attention}Enhanced{} cards give {X:mult,C:white} X#1# {} Mult",
			"when scored"
		}
	},
	rarity = 3,
	discovered = true,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 0 },
	config = { extra = { Xmult = 1.4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then 
			if context.other_card.ability.set == "Enhanced" then
				return {
					x_mult = card.ability.extra.Xmult,
					--card = self
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'succubus',
	loc_txt = {
		name = 'Succubus',
		text = {
			"Converts all {C:attention}played{}",
			"cards into {C:red}Hearts{}"
		}
	},
	config = { extra = {  } },
	rarity = 3,
	atlas = 'jokers',
	pos = { x = 3, y = 1 },
	cost = 8,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then
			for i=1, #context.full_hand do
				if not context.full_hand[i]:is_suit('Hearts') then
					SMODS.change_base(context.full_hand[i], 'Hearts')
				end
			end
			--card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Enamoured!", key = "a_mult"})
			return {
				
				message = "Enamoured!",
				colour = G.C.RED
			}
		end
	end
}

SMODS.Joker {
	key = 'thirdhand',
	loc_txt = {
		name = 'Third Hand',
		text = {
			"{C:attention}+#2#{} hand size, {C:tarot}+1{} consumable slot",
			"{C:red}#1#{} discard, {C:blue}#3#{} hand each round"
		}
	},
	config = { extra = { hand_size = 3, discard_size = -1, play_size = -1 } },
	rarity = 3,
	atlas = 'jokers',
	pos = { x = 0, y = 1 },
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discard_size, card.ability.extra.hand_size, card.ability.extra.play_size } }
	end,
	
	add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discard_size
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.play_size
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
		G.hand:change_size(card.ability.extra.hand_size)
	end,
	-- Inverse of above function.
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discard_size
		G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.play_size
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
		G.hand:change_size(-card.ability.extra.hand_size)
	end
}

SMODS.Joker {
	key = 'siffrin',
	loc_txt = {
		name = 'The Lost One',
		text = {
			"Retriggers {C:attention}every{} played card",
			"an additional time per current {C:attention}Ante{},",
			"doubled if this Joker is {C:dark_edition}Negative{}"
		}
	},
	config = { extra = { repetitions = 0, repetitionScore = 1 } },
	rarity = 4,
	atlas = 'jokers',
	pos = { x = 1, y = 3 },
	soul_pos = { x = 2, y = 3 },
	cost = 20,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions, card.ability.extra.repetitionScore } }
	end,
	update = function(self, card, dt) 
		card.ability.extra.repetitions = G.GAME.round_resets.ante
		if card.edition and card.edition.negative then
			card.ability.extra.repetitionScore = 2
		else
			card.ability.extra.repetitionScore = 1
		end
	end,
	
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and not context.blueprint then
			return {
				message = "Loop",
				colour = G.C.BLACK,
				repetitions = card.ability.extra.repetitions * card.ability.extra.repetitionScore
			}
        end
	end
}

-- SMODS.Joker{
	-- key = 'arachne',
	-- loc_txt = {
		-- name = "Arachne",
		-- text = {
			-- "{C:attention}Standard packs{} and {C:spectral}Cryptid cards{}",
			-- "will create an {C:attention}extra copy{} of",
			-- "the selected card"
		-- }
	-- },
	-- rarity = 4,
	-- discovered = true,
	-- cost = 20,
	-- blueprint_compat = true,
	-- eternal_compat = false,
	-- perishable_compat = false,
	-- atlas = "jokers",
	-- pos = { x = 5, y = 0 },
	-- soul_pos = { x = 6, y = 0 },
	-- config = { extra = { toCopy = {} } },
	-- loc_vars = function(self, info_queue, card)
		-- return { vars = { card.ability.extra.toCopy } }
	-- end,
	-- calculate = function(self, card, context)
		-- if context.playing_card_added and context.cards then
			-- for i = 1, #context.cards
			-- do
				-- -- NOTE: Figure out DNA triggering, checking the hand and using the card played instead
				-- if type(context.cards[i]) == "table" then
					-- G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					-- local _card = copy_card(context.cards[i], nil, nil, G.playing_card)
					-- _card:add_to_deck()
					-- G.deck.config.card_limit = G.deck.config.card_limit + 1
					-- table.insert(G.playing_cards, _card)
					-- G.deck:emplace(_card)
					-- G.E_MANAGER:add_event(Event({
						-- func = function()
							-- _card:start_materialize()
							-- return true
					-- end
					-- }))
                    		-- return {
                			-- message = localize('k_copied_ex'),
                			-- colour = G.C.CHIPS,
                			-- playing_cards_created = {true}
            			-- }
				-- end
			-- end
		-- end
	-- end
-- }

----------------------------------------------
------------MOD CODE END----------------------