function draw(amount, friendly, enemy, steal) -- draw cards
	--drawcard:play()
	if steal == true then -- if the decks are swapped so players steal from eachother
		if friendly ~= false then -- if friendly draws
			Timer.addPeriodic(1.25, function()
	    	tohand(friendlyhand, enemydeck[1])
	    	table.remove(enemydeck, 1)
			end, amount)
		end
		if enemy == true then -- if enemy draws
			Timer.addPeriodic(1.25, function()
	    	tohand(enemyhand, friendlydeck[1])
	    	table.remove(friendlydeck, 1)
			end, amount)
		end
	else -- if decks are not swapped
		if friendly ~= false then -- if friendly draws
	    drawn = 1
			Timer.addPeriodic(1.25, function()
				if drawn <= amount then
					drawn = drawn + 1
					tohand(friendlydeck)
				end
			end)
				sendmsg('{"cmd": "draw"}')
		end
		if enemy == true then -- if enemy draws
			Timer.addPeriodic(1.25, function()
	    	tohand(enemyhand, enemydeck[1])
	    	table.remove(enemydeck, 1)
			end, amount)
		end
	end
end

function givecard(id, friendly, enemy)
	if friendly ~= false then
		tohand(friendlyhand, id)
	end
	if enemy == true then
		tohand(enemyhand, id)
	end
end

function wealthup(amount, friendly, enemy) -- gain extra wealth this turn
	if friendly ~= false then
		friendlywealth = friendlywealth + amount
	end
	if enemy == true then
		enemywealth = enemywealth + amount
	end
end