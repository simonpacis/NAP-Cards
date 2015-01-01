function draw(amount, friendly, enemy, steal) -- draw cards
	if steal == true then -- if the decks are swapped so players steal from eachother
		if friendly ~= false then -- if friendly draws
			for i = 1, amount do
	    	tohand(friendlyhand, enemydeck[1])
	    	table.remove(enemydeck, 1)
			end
		end
		if enemy == true then -- if enemy draws
			for i = 1, amount do
	    	tohand(enemyhand, friendlydeck[1])
	    	table.remove(friendlydeck, 1)
			end
		end
	else -- if decks are not swapped
		if friendly ~= false then -- if friendly draws
			num = 1
			for i = 1, amount do
	    	tohand(friendlyhand, friendlydeck[1])
	    	table.remove(friendlydeck, 1)
			end
		end
		if enemy == true then -- if enemy draws
			for i = 1, amount do
	    	tohand(enemyhand, enemydeck[1])
	    	table.remove(enemydeck, 1)
			end
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