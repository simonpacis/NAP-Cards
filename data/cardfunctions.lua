function draw(amount, steal) -- draw cards
	--drawcard:play()
	drawing = true
	if steal == true then -- if the decks are swapped so players steal from eachother
	else -- if decks are not swapped
	  drawn = 1
		Timer.addPeriodic(1.25, function()
			if drawn <= amount then
				drawn = drawn + 1
				tohand(friendlydeck)
				sendcmd('enemydraw()')
				playsound("drawcard")
			end
		end)
		Timer.add((1.25*amount + 1.25), function()
			if addtodraw ~= nil then
				tohand(nil, addtodraw)
				sendcmd('enemydraw()')
				playsound("drawcard")
			end
			drawing = false
		end)
	end
end

function givecard(id)
	if drawing == false or drawing == nil then
		tohand(nil, id)
		sendcmd('enemydraw()')
	else
		addtodraw = id
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