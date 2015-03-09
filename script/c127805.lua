--叛逆的分影 「时崎狂三」
function c127805.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85138716,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c127805.spcost)
	e1:SetTarget(c127805.sptg)
	e1:SetOperation(c127805.spop)
	c:RegisterEffect(e1)
	if not c127805.global_check then
		c127805.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c127805.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,127805)
	e2:SetCost(c127805.cost)
	e2:SetTarget(c127805.target)
	e2:SetOperation(c127805.operation)
	c:RegisterEffect(e2)
end
function c127805.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p1=nil
	local p2=nil
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x9fa)  then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,127805,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,127805,RESET_PHASE+PHASE_END,0,1) end
end
function c127805.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c127805.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c127805.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9fa) 
end
function c127805.filter(c,e,tp)
	return c:IsSetCard(0x9fa) and c:IsType(TYPE_MONSTER)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c127805.filter2(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c127805.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c127805.filter,tp,LOCATION_HAND,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:IsExists(c127805.filter2,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c127805.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c127805.filter,tp,LOCATION_HAND,0,nil,e,tp)
	local dg=g:Filter(c127805.filter2,nil,g)
	if dg:GetCount()>=1 then
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		dg:RemoveCard(tc1)
		local tc2=dg:Filter(Card.IsCode,nil,tc1:GetCode()):GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		tc1:RegisterFlagEffect(c127805,RESET_EVENT+0x1fe0000,0,1,fid)
		tc2:RegisterFlagEffect(c127805,RESET_EVENT+0x1fe0000,0,1,fid)
		Duel.SpecialSummonComplete()
		sg:AddCard(tc2)
		sg:KeepAlive()
	end
end
function c127805.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c127805.sfilter(c)
	return c:IsSetCard(0x9fa) and c:IsType(TYPE_MONSTER)  and c:IsAbleToHand()
end
function c127805.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c127805.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c127805.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c127805.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
