--被厌恶者的哲学
function c93300013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c93300013.cost)
	e1:SetTarget(c93300013.target)
	e1:SetOperation(c93300013.activate)
	c:RegisterEffect(e1)
	if not c93300013.global_check then
		c93300013.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c93300013.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c93300013.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c93300013.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsControler(tp) and tc:IsPreviousLocation(LOCATION_DECK) and not tc:IsReason(REASON_DRAW) then
			c93300013[tc:GetControler()]=false
		end
		tc=eg:GetNext()
	end
end
function c93300013.clear(e,tp,eg,ep,ev,re,r,rp)
	c93300013[0]=true
	c93300013[1]=true
end
function c93300013.filter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemoveAsCost()
end
function c93300013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,93300013)==0 and c93300013[tp] and Duel.IsExistingMatchingCard(c93300013.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c93300013.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,93300013,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(LOCATION_DECK,0)
	Duel.RegisterEffect(e1,tp)
end
function c93300013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c93300013.filter2(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c93300013.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,3,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c93300013.filter2,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c93300013.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
