--意外的邂逅
function c11112020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11112020+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11112020.condition)
	e1:SetCost(c11112020.cost)
	e1:SetTarget(c11112020.target)
	e1:SetOperation(c11112020.activate)
	c:RegisterEffect(e1)
	if not c11112020.global_check then
		c11112020.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c11112020.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c11112020.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if not tc:IsSetCard(0x15b) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,11112020,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,11112020,RESET_PHASE+PHASE_END,0,1) end
end
function c11112020.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15b)
end
function c11112020.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c11112020.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11112020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11112020)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+RESET_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11112020.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c11112020.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x15b)
end
function c11112020.filter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x15b) and c:IsAbleToHand()
end
function c11112020.filter2(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x15b)
end
function c11112020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11112020.filter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c11112020.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11112020.filter2,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
	    Duel.DiscardDeck(tp,2,REASON_EFFECT)
	end
end