--2
function c18712302.initial_effect(c)
	c:EnableReviveLimit()
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,18712302)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c18712302.target)
	e3:SetOperation(c18712302.operation)
	c:RegisterEffect(e3)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95027497,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,18712302)
	e3:SetTarget(c18712302.ptarget)
	e3:SetOperation(c18712302.poperation)
	c:RegisterEffect(e3)
end
function c18712302.mat_check(c)
    return not c:IsCode(111111)
end
function c18712302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c18712302.defilter,tp,LOCATION_EXTRA,0,1,nil,7,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c18712302.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local slv=7
	local sg=Duel.GetMatchingGroup(c18712302.defilter,tp,LOCATION_EXTRA,0,nil,slv,e,tp)
	if sg:GetCount()==0 then return end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		slv=slv-tc:GetLevel()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		sg:Remove(Card.IsLevelAbove,nil,slv+1)
		ft=ft-1
	until ft<=0 or sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(18712302,1))
	Duel.SpecialSummonComplete()
end
function c18712302.ptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18712302.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c18712302.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18712302.poperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18712302.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.Release(g,REASON_EFFECT)
	local cg=Duel.SelectMatchingCard(tp,c18712302.defilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,2,nil,tp)
	local tc1=cg:GetFirst()
	if tc1 then
		Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	local tc2=cg:GetNext()
	if tc2 then
		Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end	
end
function c18712302.defilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_PENDULUM)
end
function c18712302.desfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsReleasable()
end