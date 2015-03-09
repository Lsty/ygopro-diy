--就算死也要保护你
function c116811170.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,116811170+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c116811170.spcon)
	e1:SetCost(c116811170.spcost)
	e1:SetTarget(c116811170.sptg)
	e1:SetOperation(c116811170.spop)
	c:RegisterEffect(e1)
end
function c116811170.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c116811170.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetMatchingGroupCount(c116811170.cfilter,tp,LOCATION_MZONE,0,nil)
end
function c116811170.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x3e2) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116811170.efilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e2) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c116811170.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c116811170.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFlagEffect(tp,116811170)~=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
		local ct=Duel.GetMatchingGroupCount(c116811170.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return ct>0 and Duel.IsExistingMatchingCard(c116811170.efilter,tp,LOCATION_SZONE,0,1,nil)
	end
	local ct=Duel.GetMatchingGroupCount(c116811170.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local g=Duel.SelectMatchingCard(tp,c116811170.efilter,tp,LOCATION_SZONE,0,1,99,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
	Duel.RegisterFlagEffect(tp,116811170,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g:GetCount(),tp,LOCATION_DECK)
end
function c116811170.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return end
	local g=Duel.GetMatchingGroup(c116811170.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,ct,ct,nil)
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(116811170,RESET_EVENT+0x1fe0000,0,1)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	Duel.Damage(tp,ct*500,REASON_EFFECT)
end