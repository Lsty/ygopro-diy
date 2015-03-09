--世界创造
function c24094670.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24094670,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24094670.target)
	e1:SetOperation(c24094670.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(24094670,1))
	e2:SetCost(c24094670.cost)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(24094670,2))
	e3:SetCost(c24094670.cost)
	e3:SetLabel(2)
	c:RegisterEffect(e3)
end
function c24094670.filter1(c)
	return c:IsType(TYPE_FIELD)
end
function c24094670.filter2(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c24094670.filter3(c)
	return c:GetType()==TYPE_SPELL
end
function c24094670.rfilter(c)
	return c:IsCode(24094670) and c:IsAbleToRemoveAsCost()
end
function c24094670.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c24094670.rfilter,tp,LOCATION_GRAVE,0,ct,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24094670.rfilter,tp,LOCATION_GRAVE,0,ct,ct,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c24094670.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then 
		if ct==0 then return Duel.IsExistingMatchingCard(c24094670.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
		elseif ct==1 then return Duel.IsExistingMatchingCard(c24094670.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		else return Duel.IsExistingMatchingCard(c24094670.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	end
end
function c24094670.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24094670,ct))
	if ct==0 then g=Duel.SelectMatchingCard(tp,c24094670.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	elseif ct==1 then g=Duel.SelectMatchingCard(tp,c24094670.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	else g=Duel.SelectMatchingCard(tp,c24094670.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) end
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end