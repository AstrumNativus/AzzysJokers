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
			if (context.other_card == context.scoring_hand[#context.scoring_hand]) and not context.other_card.debuff then
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
				if (context.other_card == context.scoring_hand[1]) and not context.other_card.debuff then
					return {
						message = localize('k_again_ex'),
						repetitions = card.ability.extra.repetitions
					}
				end
			elseif #context.scoring_hand == 3 then
				if (context.other_card == context.scoring_hand[2]) and not context.other_card.debuff then
					return {
						message = localize('k_again_ex'),
						repetitions = card.ability.extra.repetitions
					}
				end
			elseif #context.scoring_hand == 5 then
				if (context.other_card == context.scoring_hand[3]) and not context.other_card.debuff then
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
			"Gains {C:chips}+5{} Chips for each {C:attention}7{} played,",
			"every {C:chips}30{} Chips gained increases {C:attention}sell",
			"{C:attention}value{} by {C:money}$1{}, doubles payout at {C:money}$7{}",
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
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chipHold, card.ability.extra.chipCount } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 7 and not context.blueprint then
				card.ability.extra.chipHold = card.ability.extra.chipHold + 5
				card.ability.extra.chipCount = card.ability.extra.chipCount + 5
				if card.ability.extra.chipCount >= 30 and not context.blueprint then
					card.ability.extra_value = card.ability.extra_value + 1
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
			if card.ability.extra_value >= 7 then
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
	key = 'fossil',
	loc_txt = {
		name = 'Fossil',
		text = {
			"Earn {C:money}$4{} every {C:attention}15{}",
			"cards discarded {C:inactive}[#1#]{}"
		}
	},
	config = { extra = { discardCount = 0 } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 9, y = 3 },
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discardCount } }
	end,
	calculate = function(self, card, context)
		if context.discard and not context.blueprint then
			card.ability.extra.discardCount = card.ability.extra.discardCount + 1
			if (card.ability.extra.discardCount >= 15) then
				card.ability.extra.discardCount = card.ability.extra.discardCount - 15
				ease_dollars(4)
				return {
					message = "Discovered!",
					colour = G.C.BROWN
				}
			end
        end
	end
}

SMODS.Joker {
	key = 'goat',
	loc_txt = {
		name = 'Goat',
		text = {
			"{C:attention}Destroys{} a random",
			"card {C:attention}held in hand{}",
			"and earns {C:money}$1{}"
		}
	},
	config = { extra = { goatCard = {} } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 3, y = 6 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.goatCard } }
	end,
	calculate = function(self, card, context)
		if context.before and context.main_eval then
			card.ability.extra.goatCard = pseudorandom_element(G.hand.cards, pseudoseed('goat'))
		elseif context.destroy_card and context.cardarea == G.hand then
			if context.destroy_card == card.ability.extra.goatCard then
				ease_dollars(1)
				return { message = "Eaten!", remove = true }
			end
		end
	end
}

SMODS.Joker {
	key = 'goblinhoard',
	loc_txt = {
		name = 'Goblin Hoard',
		text = {
			"Earn {C:money}$3{} if played hand",
			"contains {C:attention}3{} or fewer cards"
		}
	},
	config = { extra = {  } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 0, y = 6 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if context.full_hand and #context.full_hand <= 3 then
				ease_dollars(3)
				return {
					message = "Pillage"
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
					if context.full_hand[i].base.suit == context.other_card.base.suit and not context.full_hand[i].debuff then
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
				if context.full_hand[i]:get_id() == 4 and not context.full_hand[i].debuff then
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

SMODS.Joker {
	key = 'taxreturn',
	loc_txt = {
		name = 'Tax Return',
		text = {
			"Entering a {C:attention}shop{} with",
			"less than {C:money}$10{} will earn",
			"{C:money}$1{} per held {C:attention}Joker{}"
		}
	},
	config = { extra = {  } },
	rarity = 1,
	atlas = 'jokers',
	pos = { x = 5, y = 5 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	
	calculate = function(self, card, context)
		if context.starting_shop then
			if G.GAME.dollars < 10 then
				ease_dollars(#G.jokers.cards)
				return {
					message = "Return!",
					colour = G.C.MONEY
				}
			end
        end
	end,
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
	enhancement_gate = 'm_stone',
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

SMODS.Joker{
	key = 'wildgrowth',
	loc_txt = {
		name = "Wild Growth",
		text = {
			"Increases {C:attention}rank{} of",
			"scored cards by {C:attention}1{}"
		}
	},
	rarity = 1,
	discovered = true,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 9, y = 4 },
	config = { extra = { canIncrease = true } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.canIncrease } }
	end,
	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then-- and card.ability.extra.canIncrease then 
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Growth!", colour = G.C.GREEN})
			for i=1, #context.scoring_hand do
				if not context.scoring_hand[i].debuff then
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.0,func = function()
						local _card = context.scoring_hand[i]
						local suit_prefix = string.sub(_card.base.suit, 1, 1)..'_'
						local rank_suffix = _card.base.id == 14 and 2 or math.min(_card.base.id+1, 14)
						if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
						elseif rank_suffix == 10 then rank_suffix = 'T'
						elseif rank_suffix == 11 then rank_suffix = 'J'
						elseif rank_suffix == 12 then rank_suffix = 'Q'
						elseif rank_suffix == 13 then rank_suffix = 'K'
						elseif rank_suffix == 14 then rank_suffix = 'A'
						end
						_card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
						
					return true end }))
				end
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
		if context.before and context.cardarea == G.jokers then
			if not context.blueprint then
				local suits = {
					['Hearts'] = 0,
					['Diamonds'] = 0,
					['Spades'] = 0,
					['Clubs'] = 0
				}
				for i = 1, #context.scoring_hand do
					if context.scoring_hand[i].ability.name ~= 'Wild Card' and not context.scoring_hand[i].debuff then
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
					if context.scoring_hand[i].ability.name == 'Wild Card' and not context.scoring_hand[i].debuff then
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
			end
		elseif context.joker_main then
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
				Xmult_mod = card.ability.extra.Xmult
			}
		elseif context.after and context.cardarea == G.jokers and not context.blueprint then
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
				if context.full_hand[i] ~= context.other_card and not (context.other_card.debuff or context.full_hand[i].debuff) then
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
	key = 'brimstone',
	loc_txt = {
		name = "Brimstone",
		text = {
			"When hand {C:attention}score{} is",
			"greater than {C:attention}Blind{}",
			"requirement, earn {C:money}$6{}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 6 },
	config = { extra = { canPay = true, payLock = true } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.canPay, card.ability.extra.payLock } }
	end,
	calculate = function(self, card, context)
		-- if context.final_scoring_step and context.cardarea == G.play then
			-- local totalScore = G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult
			-- print("hey dude")
			-- if (G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult) > G.GAME.blind.chips then
				-- ease_dollars(6)
				-- return {
					-- message = "Bounty!"
				-- }
			-- end
		-- end
		if context.cardarea == G.play then
			card.ability.extra.payLock = false
		elseif context.end_of_round then
			card.ability.extra.canPay = true
		end
	end,
	
	update = function(self, card, dt) 
		if G.GAME.blind then
			if card.ability.extra.canPay and not card.ability.extra.payLock then
				if (type(G.GAME.current_round.current_hand.chips) == "number") and (type(G.GAME.current_round.current_hand.mult) == "number") then
					if ((G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult) > G.GAME.blind.chips) then
						ease_dollars(6)
						card.ability.extra.canPay = false
						card.ability.extra.payLock = true
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Bounty!", colour = G.C.RED})
					end
				end
			end
		end
	end
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
	key = 'chupacabra',
	loc_txt = {
		name = "Chupacabra",
		text = {
			"Gains {X:mult,C:white}X0.1{} Mult for",
			"each {C:attention}destroyed{} card",
			"{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 7, y = 4 },
	config = { extra = { xMult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xMult } }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards and not context.blueprint then
			for i=1, #context.removed do
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Drained!", colour = G.C.RED})
				card.ability.extra.xMult = card.ability.extra.xMult + 0.1
			end
		elseif context.joker_main then
			return {
				x_mult = card.ability.extra.xMult
			}
		end
	end
}

SMODS.Joker{
	key = 'conman',
	loc_txt = {
		name = "Conman",
		text = {
			"{C:attention}Shops{} will contain an",
			"extra {C:attention}Joker{} that is",
			"guaranteed to have",
			"an {C:dark_edition}edition{} and either",
			"{C:spades}Eternal{} or {C:clubs}Perishable{},",
			"and a {C:green}34%{} chance",
			"to be a {C:money}Rental{}",
			"{C:red,S:0.6}(May have negative",
			"{C:red,S:0.6}results with multiple)"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 2, y = 5 },
	config = { extra = { hesitater = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hesitater } }
	end,
	
	calculate = function(self, card, context)
		
		if (context.starting_shop or context.reroll_shop) and not context.blueprint then
				_card = create_card('Joker', G.shop_jokers, nil, pseudorandom("conman"), nil, nil, nil, 'conman')
				create_shop_card_ui(_card, 'Joker', G.shop_jokers)
				_card.states.visible = false
				
				G.E_MANAGER:add_event(Event({
					func = function()
						_card:start_materialize()
						local spamtonSeed = pseudorandom("spamton")
						
						if spamtonSeed > 0.75 then
							_card:set_edition('e_negative', true)
						elseif spamtonSeed > 0.5 then
							_card:set_edition('e_polychrome', true)
						elseif spamtonSeed > 0.25 then
							_card:set_edition('e_holo', true)
						else
							_card:set_edition('e_foil', true)
						end
						
						local sponktongSeed = pseudorandom("postman")
						
						if sponktongSeed > 0.5 then
							_card.ability.eternal = true
						else
							_card.ability.perishable = true
							_card.ability.perish_tally = 5
						end
						
						local spunchtobSeed = pseudorandom("dealmaker")
						
						if spunchtobSeed > 0.66 then
							_card.ability.rental = true
						end
						
						G.shop_jokers:emplace(_card)
						_card:set_cost()
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Deal!", colour = G.C.MONEY})
						return true
					end
				}))
		end
	end,
	
	update = function(self, card, dt) 
		card.ability.extra.hesitater = card.ability.extra.hesitater + 1
		
		if (card.ability.extra.hesitater - math.floor(card.ability.extra.hesitater/5)*5) == 0 then
			local spamtonSeed = pseudorandom("spamton")
			if spamtonSeed > 0.75 then
				card:set_edition('e_polychrome', true, true)
			elseif spamtonSeed > 0.5 then
				card:set_edition('e_holo', true, true)
			elseif spamtonSeed > 0.25 then
				card:set_edition('e_foil', true, true)
			else
				card.edition = nil
			end
			
			local sponktongSeed = pseudorandom("postman")
					
			if sponktongSeed > 0.66 then
				card.ability.eternal = true
				card.ability.perishable = false
			elseif sponktongSeed > 0.33 then
				card.ability.perishable = true
				card.ability.eternal = false
				card.ability.perish_tally = sponktongSeed * 100
			else 
				card.ability.eternal = false
				card.ability.perishable = false
			end
			
			local seed = pseudorandom("conman")
			
			if seed > 0.5 then
				card.ability.rental = true
			else
				card.ability.rental = false
			end
		end
	end,
}

SMODS.Joker{
	key = 'curiosity',
	loc_txt = {
		name = "Curiosity",
		text = {
			"Using a {C:planet}Planet{} card has",
			"a {C:green}#2# in 2{} chance of",
			"increasing the {C:attention}hand",
			"level a {C:attention}second{} time"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 5 },
	config = { extra = { odds = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.odds, (G.GAME.probabilities.normal or 1) } }
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
			if pseudorandom("curiosity") < G.GAME.probabilities.normal / card.ability.extra.odds then
			
				local text,disp_text = context.consumeable.ability.hand_type
				
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
                level_up_hand(context.blueprint_card or card, text, nil, 1)
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
			end
		end
	end
}

SMODS.Joker {
	key = 'dragonmark',
	loc_txt = {
		name = 'Dragon Mark',
		text = {
			"{C:chips}-1{} hand during {C:attention}Small{}",
			"and {C:attention}Big Blinds{}, {C:chips}+2{} hands",
			"during {C:attention}Boss Blinds{}"
		}
	},
	config = { extra = { } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 1, y = 6 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if G.GAME.blind.boss then
				ease_hands_played(2)
			else
				ease_hands_played(-1)
			end
        end
	end
}

SMODS.Joker{
	key = 'fangirl',
	loc_txt = {
		name = "Fangirl",
		text = {
			"Gains {C:chips}+10{} Chips each time a",
			"card changes its {C:attention}base suit{}",
			"{C:inactive}(Currently{} {C:chips}+#1#{} {C:inactive}Chips){}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 9, y = 5 },
	config = { extra = { chipStore = 0, refHand = {} } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chipStore, card.ability.extra.refHand } }
	end,
	calculate = function(self, card, context)
		if context.suit_change and not context.blueprint then
			card.ability.extra.chipStore = card.ability.extra.chipStore + 10
			SMODS.calculate_effect({message=localize("k_upgrade_ex")}, card)
		elseif context.joker_main then
			return {
				chips = card.ability.extra.chipStore
			}
		end
	end
}

local suitChanger = Card.change_suit
function Card:change_suit(new_suit)
	suitChanger(self,new_suit)
    for _,J in ipairs(G.jokers.cards)do
        J:calculate_joker({suit_change=true})
    end
end

SMODS.Joker {
	key = 'harionago',
	loc_txt = {
		name = 'Harionago',
		text = {
			"Gains {X:mult,C:white}X0.5{} Mult each {C:attention}consecutive{}",
			"{C:attention}Straight{} or {C:attention}Straight Flush{} played,",
			"resets if {C:attention}any other hand{} is played",
			"{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
		}
	},
	config = { extra = { xMult = 1 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 7, y = 3 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xMult } }
	end,
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Straight'] or context.poker_hands['Straight Flush']) and not context.blueprint then
			card.ability.extra.xMult = card.ability.extra.xMult + 0.5
			return {
				message = localize("k_upgrade_ex")
			}
		elseif context.before and (context.scoring_name ~= 'Straight' or 'Straight Flush') and not context.blueprint then
			card.ability.extra.xMult = 1
			return {
				message = localize("k_reset")
			}
		elseif context.joker_main then
			return {
				x_mult = card.ability.extra.xMult
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
	key = 'hourglass',
	loc_txt = {
		name = 'Hourglass',
		text = {
			"Loses {X:mult,C:white}X0.5{} Mult each",
			"round, restored when",
			"a {C:attention}Blind{} is {C:attention}skipped{}",
			"{C:inactive}(Currently{} {X:mult,C:white}X#1#{} {C:inactive}Mult){}"
		}
	},
	config = { extra = { xMult = 3 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 4, y = 5 },
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xMult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xMult
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.extra.xMult = card.ability.extra.xMult - 0.5
			if card.ability.extra.xMult == 1 then
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
					message = 'Ran Out!'
				}
			else
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Lowered", colour = G.C.ATTENTION})
			end
		elseif context.skip_blind and not context.blueprint then
			card.ability.extra.xMult = 3
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset!", colour = G.C.ATTENTION})
		end
	end
}

SMODS.Joker {
	key = 'huntsman',
	loc_txt = {
		name = 'Huntsman',
		text = {
			"Each {C:attention}Jack{} held",
			"in hand scores",
			"{C:chips}+#1#{} Chips"
		}
	},
	config = { extra = { chipScore = 125 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 3, y = 5 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chipScore } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			if context.other_card:get_id() == 11 then
				return {
					chips = card.ability.extra.chipScore
				}
			end
		end
	end
}

SMODS.Joker{
	key = 'jormungandr',
	loc_txt = {
		name = "Jormungandr",
		text = {
			"{C:attention}Wild Cards{} randomly",
			"score either",
			"{C:chips}+60{} Chips or {C:mult}+8{} Mult"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 4 },
	config = { extra = { } },
	enhancement_gate = 'm_wild',
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then 
			if context.other_card.config.center_key == "m_wild" and not context.other_card.debuff then
				local randoBrain = pseudoseed("jormungandr")
				if randoBrain > 0.51 then
					return {
						mult = 8
					}
				else
					return {
						chips = 60
					}
				end
			end
		end
	end
}

SMODS.Joker{
	key = 'metaljacket',
	loc_txt = {
		name = "Metal Jacket",
		text = {
			"{C:attention}Steel Cards{} can't",
			"be {C:red}debuffed{}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 7,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 5 },
	enhancement_gate = 'm_steel',
	config = { extra = { } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	--calculate = function(self, card, context)
	update = function(self, card, dt) 
		if G.hand then 
			for i=1, #G.hand.cards do
				if G.hand.cards[i].config.center_key == "m_steel" then
					if G.hand.cards[i].debuff then
						G.hand.cards[i].debuff = false
					end
				end
			end
		end
	end
}

SMODS.Joker{
	key = 'mimic',
	loc_txt = {
		name = "Mimic",
		text = {
			"Gains {C:chips}+1{} Chips for",
			"every {C:money}$1{} spent",
			"{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips){}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 8, y = 3 },
	config = { extra = { storedChips = 0, moneyTrack = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.storedChips, card.ability.extra.moneyTrack } }
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.storedChips
			}
		end
	end,
	
	update = function(self, card, dt) 
		if card.ability.extra.moneyTrack ~= G.GAME.dollars then
			if card.ability.extra.moneyTrack > G.GAME.dollars then
				card.ability.extra.storedChips = card.ability.extra.storedChips + ((card.ability.extra.moneyTrack - G.GAME.dollars))
			end
			card.ability.extra.moneyTrack = G.GAME.dollars
			if card.ability.extra.moneyTrack > G.GAME.dollars then
				return {
					message = "Upgrade",
					colour = G.C.PURPLE
				}
			end
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
				if context.other_card:get_id() == card.ability.extra.targetid and context.other_card:is_suit('Diamonds') and not context.other_card.debuff then
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
			if context.other_card:is_face() and not context.other_card.debuff then
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

SMODS.Joker{
	key = 'rootbeer',
	loc_txt = {
		name = "Root Beer",
		text = {
			"Creates a random {C:attention}Tag{} after",
			"defeating the {C:attention}Boss Blind{} if",
			"no {C:attention}skips{} were used during the Ante"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 3 },
	config = { extra = { canGiveTag = true } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.canGiveTag } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and card.ability.extra.canGiveTag then
			if G.GAME.last_blind and G.GAME.last_blind.boss then
				local tag_pool = get_current_pool('Tag')
				local selectedTag = pseudorandom_element(tag_pool, pseudoseed("rootbeer"))
				local it = 1
				while selectedTag == 'UNAVAILABLE' do
					it = it + 1
					selectedTag = pseudorandom_element(tag_pool, pseudoseed("rootbeer"))
				end
				G.E_MANAGER:add_event(Event({
                    func = (function()
						add_tag(Tag(selectedTag, 'Small'))
						play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
					end)
				}))
				return {
					message = "Tag!",
					colour = G.C.ORANGE
				}
			end
		elseif context.end_of_round and context.cardarea == G.jokers and not card.ability.extra.canGiveTag then
			if G.GAME.last_blind and G.GAME.last_blind.boss then
				card.ability.extra.canGiveTag = true
				return {
					message = "Fresh!",
					colour = G.C.ORANGE
				}
			end
		elseif context.skip_blind then
			card.ability.extra.canGiveTag = false
			return {
				message = "Spoiled",
				colour = G.C.BROWN
			}
		end
	end
}

SMODS.Joker {
	key = 'scavenger',
	loc_txt = {
		name = 'Scavenger',
		text = {
			"{C:planet}Planet{}, {C:tarot}Tarot{}, and {C:spectral}Spectral{}",
			"cards also earn {C:attention}twice{} their",
			"{C:attention}sell value{} when used"
		}
	},
	config = { extra = {  } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 8, y = 4 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	
	calculate = function(self, card, context)
		if context.using_consumeable then
			ease_dollars(context.consumeable.sell_cost * 2)
			return {
				message = "Salvaged!",
				colour = G.C.ORANGE
			}
		end
	end
}

SMODS.Joker {
	key = 'shapeshifter',
	loc_txt = {
		name = 'Shapeshifter',
		text = {
			"Copies the {C:attention}first scored card{}",
			"in a {C:attention}played{} hand onto a",
			"{C:attention}random{} card {C:attention}held in hand{}"
		}
	},
	config = { extra = {  } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 2, y = 6 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card == context.scoring_hand[1] then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Morph!"})
				local kastaCard = pseudorandom_element(G.hand.cards, pseudorandom('shapeshifter'))
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = (function()
						copy_card(context.scoring_hand[1], kastaCard)
						kastaCard:juice_up(0.3, 0.3)
					return true
				end)}))
			end
		end
	end
}

SMODS.Joker {
	key = 'stonemask',
	loc_txt = {
		name = 'Stone Mask',
		text = {
			"All played {C:attention}face{} cards",
			"become {C:attention}Stone{} cards",
			"when scored"
		}
	},
	config = { extra = {  } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 7, y = 5 },
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	
	calculate = function(self, card, context)
		if context.cardarea == G.jokers then
			if context.before and not context.blueprint then
				local faces = {}
				for k, v in ipairs(context.scoring_hand) do
                    if v:is_face() then 
                    faces[#faces+1] = v
                    v:set_ability(G.P_CENTERS.m_stone, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
                    end
                end
                if #faces > 0 then 
                    return {
                        message = "Stoned",
                        colour = G.C.PURPLE,

                        }
                end
			end
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
				if context.scoring_hand[i].ability.name ~= 'Wild Card' and not context.scoring_hand[i].debuff  then
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
				if context.scoring_hand[i].ability.name == 'Wild Card' and not context.scoring_hand[i].debuff then
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

SMODS.Joker{
	key = 'voyager',
	loc_txt = {
		name = "Voyager",
		text = {
			"Creates the scored hand's",
			"{C:planet}Planet{} card if the",
			"hand has 3 {C:attention}face cards{}"
		}
	},
	rarity = 2,
	discovered = true,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 5 },
	config = { extra = { canCard = false, cardCheck = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.canCard, card.ability.extra.cardCheck } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			for i=1, #context.full_hand do
				if context.full_hand[i]:is_face() and not context.full_hand[i].debuff then
					card.ability.extra.cardCheck = card.ability.extra.cardCheck + 1
					if card.ability.extra.cardCheck >= 3 then
						card.ability.extra.canCard = true
					end
				end
			end
			if card.ability.extra.canCard then
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					local card_type = 'Planet'
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.0,
						func = (function()
							if G.GAME.last_hand_played then
								local _planet = 0
								for k, v in pairs(G.P_CENTER_POOLS.Planet) do
									if v.config.hand_type == G.GAME.last_hand_played then
										SMODS.add_card{key = v.key}
									end
								end
							end
							G.GAME.consumeable_buffer = 0
							card.ability.extra.canCard = false
						return true
					end)}))
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
				else
					card.ability.extra.canCard = false
				end
			end
		else
			card.ability.extra.canCard = false
			card.ability.extra.cardCheck = 0
		end
	end
}

SMODS.Joker{
	key = 'butterfingers',
	loc_txt = {
		name = "Butterfingers",
		text = {
			"If your {C:attention}first played hand{} isn't your",
			"{C:attention}most{} played hand, gain another {C:chips}Hand{}",
			"{C:red}or{}",
			"if your {C:attention}first discard{} is your {C:attention}most{}",
			"played hand, gain another {C:mult}Discard{}"
		}
	},
	rarity = 3,
	discovered = true,
	cost = 7,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 5 },
	config = { extra = {  } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if ((G.GAME.current_round.discards_used <= 0) and (G.GAME.current_round.hands_played == 0)) and context.pre_discard and not context.hook and not context.blueprint then
			local discHand = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
			
			if discHand.name == G.GAME.current_round.most_played_poker_hand.name then
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Oops!", colour = G.C.RED})
						ease_discard(1)
					return true
				end)}))
			end
		elseif ((G.GAME.current_round.discards_used <= 0) and (G.GAME.current_round.hands_played == 0)) and context.before and context.main_eval and not context.blueprint then
		
			if scoring_hand ~= G.GAME.current_round.most_played_poker_hand then
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Oops!", colour = G.C.BLUE})
						ease_hands_played(1)
					return true
				end)}))
			end
			
		end
	end
}

SMODS.Sound({
    --vol = 0.6,
    --pitch = 0.7,
    key = "frypan",
    path = "frypan.ogg",
})

SMODS.Joker {
	key = 'burntpan',
	loc_txt = {
		name = "Burnt Pan",
		text = {
			"Scores {X:mult,C:white}X4{} Mult on every",
			"{C:attention}fourth{} consecutive hand that",
			"is the {C:attention}same poker hand{} {C:inactive}[#2#]{}"
		}
	},
	rarity = 3,
	discovered = true,
	cost = 9,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 6 },
	config = { extra = { Xmult = 4, handTrack = 0, panHand = "" } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.handTrack, card.ability.extra.panHand } }
	end,
	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then
		
			if card.ability.extra.panHand ~= context.scoring_name then
				if card.ability.extra.panHand == "" then
					card.ability.extra.panHand = context.scoring_name
				else
					card.ability.extra.handTrack = 0
					card.ability.extra.panHand = context.scoring_name
					return {
						message = localize("k_reset")
					}
				end
				
			elseif card.ability.extra.panHand == context.scoring_name then
				card.ability.extra.handTrack = card.ability.extra.handTrack + 1
				if card.ability.extra.handTrack == 4 then
                    local eval = function(_card) return (_card.ability.extra.handTrack == 4) end
                    juice_card_until(card, eval, true)
				end
			end
			
		elseif context.joker_main then
			if card.ability.extra.handTrack == 4 then
				card.ability.extra.handTrack = 0
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.5,
					func = (function()
						play_sound('azzy_frypan')
					return true
				end)}))
				return {
					x_mult = card.ability.extra.Xmult,
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

SMODS.Joker{
	key = 'dullahan',
	loc_txt = {
		name = "Dullahan",
		text = {
			"Destroys scored {C:attention}debuffed{}",
			"cards and gains {X:mult,C:white}X0.1{}",
			"Mult for each one",
			"{C:inactive}(Currently{} {X:mult,C:white}X#1#{} {C:inactive}Mult){}"
		}
	},
	rarity = 3,
	discovered = true,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 6 },
	config = { extra = { xMult = 1, runKill = true } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xMult, card.ability.extra.runKill } }
	end,
	calculate = function(self, card, context)
		if context.destroy_card and context.cardarea == G.play then 
			if card.ability.extra.runKill then
				local destroyed_cards = {}
				if context.destroying_card.debuff and not context.blueprint then
					card.ability.extra.xMult = card.ability.extra.xMult + 0.1
					return { message = "Slain", colour = G.C.MULT, remove = true }
				end
			end
		elseif context.joker_main then
			card.ability.extra.runKill = true
			return {
				x_mult = card.ability.extra.xMult
			}
		end
	end
}

SMODS.Joker {
	key = 'housewitch',
	loc_txt = {
		name = 'Housewitch',
		text = {
			"Retrigger all",
			"{C:attention}seal{} effects"
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
		--Red Seals
		if context.cardarea == G.play and context.repetition then
			if context.other_card.seal == "Red" and not context.other_card.debuff then 
				return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		elseif context.cardarea == G.play and context.individual then
			if context.other_card.seal == "Gold" and not context.other_card.debuff then 
				ease_dollars(3)
			end
		--Red and Blue Seals
        elseif context.cardarea == G.hand and context.repetition then
			if ((context.other_card.seal == "Red" or (context.other_card.seal == "Blue" and context.end_of_round)) and not context.other_card.debuff)  then 
				return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		--Purple Seals
		elseif context.discard then
			if ((context.other_card.seal == "Purple") and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) and not context.other_card.debuff  then 
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

SMODS.Joker {
	key = 'infinitecorridor',
	loc_txt = {
		name = 'Infinite Corridor',
		text = {
			"{C:attention}Scored{} cards give {X:mult,C:white}X#1#{} Mult if",
			"if they have an {C:dark_edition}edition",
			"{C:inactive}(This Joker's effects are enhanced",
			"{C:inactive}based on what edition it has)",
		}
	},
	config = { extra = { foilMult = 2 } },
	rarity = 3,
	atlas = 'jokers',
	pos = { x = 6, y = 4 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.foilMult } }
	end,
	
	update = function(self, card, dt) 
		if card.edition and card.edition.foil then
			card.ability.extra.foilMult = 2.25
		elseif card.edition and card.edition.holo then
			card.ability.extra.foilMult = 2.5
		elseif card.edition and card.edition.polychrome then
			card.ability.extra.foilMult = 2.75
		elseif card.edition and card.edition.negative then
			card.ability.extra.foilMult = 3
		else
			card.ability.extra.foilMult = 2
		end
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.edition  then
				if context.other_card.debuff then
					return {
						message = localize('k_debuffed'),
						colour = G.C.RED,
					}
				else
					return {
						x_mult = card.ability.extra.foilMult
					}
				end
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

SMODS.Joker{
	key = 'jimbobross',
	loc_txt = {
		name = "Jimbob Ross",
		text = {
			"Gains {X:mult,C:white}X1{} Mult for each",
			"additional hand size above {C:attention}#1#{}",
			"{C:inactive}(Currently: {X:mult,C:white}X#2#{}{C:inactive} Mult)"
		}
	},
	rarity = 3,
	discovered = true,
	cost = 9,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 4 },
	config = { extra = { xMult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.starting_params.hand_size or 8), card.ability.extra.xMult } }
	end,
	
	update = function(self, card, dt)
		if G.hand then
			if (G.hand.config.card_limit - G.GAME.starting_params.hand_size) > 0 then
				card.ability.extra.xMult = G.hand.config.card_limit - G.GAME.starting_params.hand_size
			end
		end
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xMult
			}
		end
	end
}

SMODS.Joker{
	key = 'jokershadow',
	loc_txt = {
		name = "#4#",
		text = {
			"#1#",
			"#2#{C:dark_edition}Negative{}",
			"#3#"
		}
	},
	rarity = 3,
	discovered = true,
	cost = 9,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 4 },
	soul_pos = { x = 1, y = 4 },
	config = { extra = { line1 = "", line2 = "", line3 = "", cardName = "", line4 = "", soulX = 99, soulY = 99, roundCount = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.line1, card.ability.extra.line2, card.ability.extra.line3, card.ability.extra.cardName, card.ability.extra.line4, card.ability.extra.soulX, card.ability.extra.soulY, card.ability.extra.roundCount  } }
	end,
	
	calculate = function(self, card, context)
		if card.edition and card.edition.negative then
			if context.first_hand_drawn then
				G.E_MANAGER:add_event(Event({
					func = function()
						local card = copy_card(pseudorandom_element(G.hand.cards, pseudoseed('shadow')), nil)

						card:set_edition('e_negative', true)
						card:add_to_deck()
						G.hand:emplace(card)
						return true
					end
				}))

				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = "Shadowed" })
				return {
					playing_cards_created = {true}
				}
			end
		else
			if context.end_of_round and context.cardarea == G.jokers then
				card.ability.extra.roundCount = card.ability.extra.roundCount - 1
				if card.ability.extra.roundCount == 0 then
					card:set_edition('e_negative', true)
				end
			end
		end
	end,
	
	update = function(self, card, dt) 
		if card.edition and card.edition.negative then
			card.ability.extra.cardName = "Joker Shadow"
			card.ability.extra.line1 = "When the Blind starts, this"
			card.ability.extra.line2 = "Joker creates a "
			card.ability.extra.line3 = "copy of a card in your hand"
		elseif card.edition and not card.edition.negative then
			card.edition = nil
		else
			card.ability.extra.cardName = "Blank Card"
			card.ability.extra.line1 = "Does nothing."
			card.ability.extra.line2 = "Becomes "
			card.ability.extra.line3 = "in "..tostring(card.ability.extra.roundCount).." round(s)."
		end
	end,
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
			card.ability.extra.card1ID = (G.deck and G.deck.cards[#G.deck.cards] and G.deck.cards[#G.deck.cards].base.value or "None")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards] and G.deck.cards[#G.deck.cards].base.suit or 'None') 
			card.ability.extra.card2ID = (G.deck and G.deck.cards[#G.deck.cards - 1] and G.deck.cards[#G.deck.cards - 1].base.value or "None")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 1] and G.deck.cards[#G.deck.cards - 1].base.suit or 'None')
			card.ability.extra.card3ID = (G.deck and G.deck.cards[#G.deck.cards - 2] and G.deck.cards[#G.deck.cards - 2].base.value or "None")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 2] and G.deck.cards[#G.deck.cards - 2].base.suit or 'None')
			card.ability.extra.card4ID = (G.deck and G.deck.cards[#G.deck.cards - 3] and G.deck.cards[#G.deck.cards - 3].base.value or "None")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 3] and G.deck.cards[#G.deck.cards - 3].base.suit or 'None')
			card.ability.extra.card5ID = (G.deck and G.deck.cards[#G.deck.cards - 4] and G.deck.cards[#G.deck.cards - 4].base.value or "None")..(" of ")..(G.deck and G.deck.cards[#G.deck.cards - 4] and G.deck.cards[#G.deck.cards - 4].base.suit or 'None') 
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
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.XmultGain } }
	end,
	calculate = function(self, card, context)
	
		if (context.cardarea == G.play or context.cardarea == G.hand) and context.individual and not context.blueprint then
			if (card.ability.extra.last_card and context.other_card == card.ability.extra.last_card) then
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

SMODS.Joker {
	key = 'rushservice',
	loc_txt = {
		name = 'Rush Service',
		text = {
			"{C:green}#2# in 3{} chance to destroy {C:attention}discarded{} cards,",
			"and earn {C:money}$1{} for each destroyed card,",
			"always destroys {C:attention}Glass Cards{}"
		}
	},
	config = { extra = { odds = 3 } },
	rarity = 3,
	atlas = 'jokers',
	pos = { x = 6, y = 3 },
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.odds, (G.GAME.probabilities.normal or 1) } }
	end,
	calculate = function(self, card, context)
		if context.discard and not context.blueprint then
			if (pseudorandom("rushservice") < G.GAME.probabilities.normal / card.ability.extra.odds) or (context.other_card.config.center_key == "m_glass" and not context.other_card.debuff) then
				ease_dollars(1)
				return {
					message = "Dropped!",
					colour = G.C.GREEN,
					remove = true
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
				if not context.full_hand[i]:is_suit('Hearts') and not context.full_hand[i].debuff then
					context.full_hand[i].change_suit(context.full_hand[i], 'Hearts')
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
	key = 'esper',
	loc_txt = {
		name = 'Esper',
		text = {
			"{C:tarot}+3{} consumable slots",
			"Creates the {C:planet}Planet{} card",
			"of each {C:attention}played hand"
		}
	},
	config = { extra = { } },
	rarity = 4,
	atlas = 'jokers',
	pos = { x = 4, y = 4 },
	soul_pos = { x = 5, y = 4 },
	cost = 20,
	
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + 3
	end,
	-- Inverse of above function.
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - 3
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				local randoBrain = pseudoseed("esper")
				if randoBrain > 0.9 then 
					SMODS.add_card{key = "c_black_hole"}
					G.GAME.consumeable_buffer = 0
				else
					local card_type = 'Planet'
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.0,
						func = (function()
							if G.GAME.last_hand_played then
								local _planet = 0
								for k, v in pairs(G.P_CENTER_POOLS.Planet) do
									if v.config.hand_type == G.GAME.last_hand_played then
										SMODS.add_card{key = v.key}
										G.GAME.consumeable_buffer = 0
									end
								end
							end
						return true
					end)}))
				end
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Create!", colour = G.C.PURPLE})
			end
		end
		-- if context.end_of_round and context.cardarea == G.jokers then
			-- for i=1, 3 do
				-- if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					-- G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					-- local randoBrain = pseudoseed("esper")
					-- if randoBrain > 0.9 then 
						-- SMODS.add_card{key = "c_black_hole"}
						-- G.GAME.consumeable_buffer = 0
					-- else
						-- local card_type = 'Planet'
						-- G.E_MANAGER:add_event(Event({
							-- trigger = 'before',
							-- delay = 0.0,
							-- func = (function()
								-- if G.GAME.last_hand_played then
									-- local _planet = 0
									-- for k, v in pairs(G.P_CENTER_POOLS.Planet) do
										-- if v.config.hand_type == G.GAME.last_hand_played then
											-- SMODS.add_card{key = v.key}
											-- G.GAME.consumeable_buffer = 0
										-- end
									-- end
								-- end
							-- return true
						-- end)}))
					-- end
					-- card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Create!", colour = G.C.PURPLE})
				-- end
			-- end
		-- end
	end
}

SMODS.Joker {
	key = 'siffrin',
	loc_txt = {
		name = 'Siffrin',
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
			if not context.other_card.debuff then
				return {
					message = "Loop",
					colour = G.C.BLACK,
					repetitions = card.ability.extra.repetitions * card.ability.extra.repetitionScore
				}
			end
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

SMODS.Back{
    name = "Sunset Deck",
    key = "sunset",
	atlas = "jokers",
    pos = {x = 9, y = 6},
    config = {  },
    loc_txt = {
        name = "Sunset Deck",
        text ={
            "{C:tarot}+1{} consumable slot",
			"{C:attention}+1{} shop slot"
        },
    },
    apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
				change_shop_size(1)
				return true
			end
		}))
    end
}

SMODS.Back{
    name = "Bonus Deck",
    key = "bonus",
	atlas = "jokers",
    pos = {x = 8, y = 6},
    config = { deckvouchers = { "v_grabber", "v_wasteful", "v_crystal_ball", "v_paint_brush", "v_blank"} },
    loc_txt = {
        name = "Bonus Deck",
        text ={
            "Start with {C:chips}Grabber{}, {C:mult}Wasteful{},",
			"{C:tarot}Crystal Ball{}, {C:attention}Paint Brush{},",
			"and {C:dark_edition}Blank{} vouchers"
        },
    },
    apply = function(self)
		for k, v in pairs(self.config.deckvouchers) do
            G.GAME.used_vouchers[v] = true
            G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					Card.apply_to_run(nil, G.P_CENTERS[v])
					return true
				end
			}))
        end
    end
}

SMODS.Back{
    name = "Zoe's Deck",
    key = "zoe",
	atlas = "jokers",
    pos = {x = 7, y = 6},
    config = {consumables = {'c_soul'}},--, 'c_black_hole'}},
    loc_txt = {
        name = "Zoe's Deck",
        text ={
            "Start with 2",
			"{C:spectral}Soul{} cards"
        },
    },
    apply = function(self)
		delay(0.4)
        G.E_MANAGER:add_event(Event({
            func = function()
				for v=1, 1 do
					local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, self.config.consumables[v], 'deck')
					card:add_to_deck()
					G.consumeables:emplace(card)
				end
				return true
            end
        }))
    end
}

SMODS.Challenge{
	key = "stardust",
	loc_txt = { name = "Stardust" },
	rules = {
		custom = {
			{id = 'no_reward'},
            {id = 'no_extra_hand_money'},
            {id = 'no_interest'}
		}, --"Only space-related Jokers will appear" },
		modifiers = {}
	},
	jokers = { 
		{ id = "j_satellite"},
		{ id = "j_azzy_esper", eternal = true }
	},
	vouchers = {
		{ id = "v_planet_merchant" },
		{id = "v_planet_tycoon"}
	},
	deck = {
        type = 'Challenge Deck',
    },
	restrictions = {
		banned_cards = {
			{id = 'v_seed_money'},
            {id = 'v_money_tree'},
			
			{id = "j_joker"},
			{id = "j_greedy_joker"},
			{id = "j_lusty_joker"},
			{id = "j_wrathful_joker"},
			{id = "j_gluttenous_joker"},
			{id = "j_jolly"},
			{id = "j_zany"},
			{id = "j_mad"},
			{id = "j_crazy"},
			{id = "j_droll"},
			{id = "j_sly"},
			{id = "j_wily"},
			{id = "j_clever"},
			{id = "j_devious"},
			{id = "j_crafty"},
			
			{id = "j_half"},
			{id = "j_stencil"},
			{id = "j_four_fingers"},
			{id = "j_mime"},
			{id = "j_credit_card"},
			{id = "j_ceremonial"},
			{id = "j_banner"},
			{id = "j_mystic_summit"},
			{id = "j_marble"},
			{id = "j_loyalty_card"},
			{id = "j_8_ball"},
			{id = "j_misprint"},
			{id = "j_dusk"},
			{id = "j_raised_fist"},
			{id = "j_chaos"},
			
			{id = "j_fibonacci"},
			{id = "j_steel_joker"},
			{id = "j_scary_face"},
			{id = "j_abstract"},
			{id = "j_delayed_grat"},
			{id = "j_hack"},
			{id = "j_pareidolia"},
			{id = "j_gros_michel"},
			{id = "j_even_steven"},
			{id = "j_odd_todd"},
			{id = "j_scholar"},
			{id = "j_business"},
			--Supernova is allowed
			{id = "j_ride_the_bus"},
			--Space Joker is allowed
			
			{id = "j_egg"},
			{id = "j_burglar"},
			{id = "j_blackboard"},
			{id = "j_runner"},
			{id = "j_ice_cream"},
			{id = "j_dna"},
			{id = "j_splash"},
			{id = "j_blue_joker"},
			{id = "j_sixth_sense"},
			--Constellation is allowed
			{id = "j_hiker"},
			{id = "j_faceless"},
			{id = "j_green_joker"},
			{id = "j_superposition"},
			{id = "j_todo_list"},
			
			{id = "j_cavendish"},
			{id = "j_card_sharp"},
			{id = "j_red_card"},
			{id = "j_madness"},
			{id = "j_square"},
			{id = "j_seance"},
			{id = "j_riff_raff"},
			{id = "j_vampire"},
			{id = "j_shortcut"},
			{id = "j_hologram"},
			{id = "j_vagabond"},
			{id = "j_baron"},
			{id = "j_cloud_9"},
			--Rocket is allowed
			--Obelisk is allowed
			
			{id = "j_midas_mask"},
			{id = "j_luchador"},
			{id = "j_photograph"},
			{id = "j_gift"},
			{id = "j_turtle_bean"},
			{id = "j_erosion"},
			{id = "j_reserved_parking"},
			{id = "j_mail"},
			{id = "j_to_the_moon"},
			{id = "j_hallucination"},
			{id = "j_fortune_teller"},
			{id = "j_juggler"},
			{id = "j_drunkard"},
			{id = "j_stone"},
			{id = "j_golden"},
			
			{id = "j_lucky_cat"},
			{id = "j_baseball"},
			{id = "j_bull"},
			{id = "j_diet_cola"},
			{id = "j_trading"},
			{id = "j_flash"},
			{id = "j_popcorn"},
			{id = "j_trousers"},
			{id = "j_ancient"},
			{id = "j_ramen"},
			{id = "j_walkie_talkie"},
			{id = "j_selzer"},
			{id = "j_castle"},
			{id = "j_smiley"},
			{id = "j_campfire"},
			
			{id = "j_ticket"},
			{id = "j_mr_bones"},
			{id = "j_acrobat"},
			{id = "j_sock_and_buskin"},
			{id = "j_swashbuckler"},
			{id = "j_troubadour"},
			{id = "j_certificate"},
			{id = "j_smeared"},
			{id = "j_throwback"},
			{id = "j_hanging_chad"},
			{id = "j_rough_gem"},
			{id = "j_bloodstone"},
			{id = "j_arrowhead"},
			{id = "j_onyx_agate"},
			{id = "j_glass"},
			
			{id = "j_ring_master"},
			{id = "j_flower_pot"},
			{id = "j_blueprint"},
			{id = "j_wee"},
			{id = "j_merry_andy"},
			{id = "j_oops"},
			{id = "j_idol"},
			{id = "j_seeing_double"},
			{id = "j_matador"},
			{id = "j_hit_the_road"},
			{id = "j_duo"},
			{id = "j_trio"},
			{id = "j_family"},
			{id = "j_order"},
			{id = "j_tribe"},
			
			{id = "j_stuntman"},
			{id = "j_invisible"},
			{id = "j_brainstorm"},
			--Satellite is allowed
			{id = "j_shoot_the_moon"},
			{id = "j_drivers_license"},
			{id = "j_cartomancer"},
			--Astronomer is allowed
			{id = "j_burnt"},
			{id = "j_bootstraps"},
			{id = "j_caino"},
			{id = "j_triboulet"},
			{id = "j_yorick"},
			{id = "j_chicot"},
			--Perkeo is allowed
			
			{id = "j_azzy_arcade"},
			{id = "j_azzy_birthdaycake"},
			{id = "j_azzy_caboose"},
			{id = "j_azzy_dartboard"},
			{id = "j_azzy_fortunecookie"},
			{id = "j_azzy_fossil"},
			{id = "j_azzy_legion"},
			{id = "j_azzy_quarternote"},
			{id = "j_azzy_revolver"},
			{id = "j_azzy_siren"},
			{id = "j_azzy_taxreturn"},
			{id = "j_azzy_warmachine"},
			{id = "j_azzy_wildgrowth"},
			
			{id = "j_azzy_amanojaku"},
			{id = "j_azzy_avantgarde"},
			{id = "j_azzy_bakeneko"},
			{id = "j_azzy_cerebral"},
			{id = "j_azzy_chupacabra"},
			{id = "j_azzy_conman"},
			--Curiosity is allowed
			{id = "j_azzy_harionago"},
			{id = "j_azzy_homunculus"},
			{id = "j_azzy_hourglass"},
			{id = "j_azzy_huntsman"},
			{id = "j_azzy_jormungandr"},
			{id = "j_azzy_metaljacket"},
			{id = "j_azzy_mimic"},
			{id = "j_azzy_mothman"},
			{id = "j_azzy_ouroborous"},
			{id = "j_azzy_princess"},
			{id = "j_azzy_rootbeer"},
			{id = "j_azzy_scavenger"},
			--Spellbook is allowed
			{id = "j_azzy_twofaced"},
			--Voyager is allowed
			
			{id = "j_azzy_doublebarrel"},
			{id = "j_azzy_housewitch"},
			--Infinite Corridor is allowed
			{id = "j_azzy_jadedragon"},
			{id = "j_azzy_jimbobross"},
			{id = "j_azzy_jokershadow"},
			{id = "j_azzy_overmind"},
			{id = "j_azzy_punchcard"},
			{id = "j_azzy_recitation"},
			{id = "j_azzy_rushservice"},
			{id = "j_azzy_spotlight"},
			{id = "j_azzy_succubus"},
			{id = "j_azzy_thirdhand"},
			
			--Esper is allowed
			{id = "j_azzy_siffrin"}
		}, 
		banned_tags = {
        },
        banned_other = {
        }
	}
}

----------------------------------------------
------------MOD CODE END----------------------