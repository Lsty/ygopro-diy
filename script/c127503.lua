--时幻古神 诺登丝
function c127503.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c127503.cost)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c127503.sptg)
	e2:SetOperation(c127503.spop)
	c:RegisterEffect(e2)
end
function c127503.cfilter(c)
	return c:IsFaceup() and c:IsAbleToDeckAsCost() and c:IsSetCard(0x7fa) and c:IsType(TYPE_PENDULUM)
end
function c127503.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,127503)==0
	and Duel.IsExistingTarget(c127503.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c127503.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()~=1 then return end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.RegisterFlagEffect(tp,127503,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c127503.filter(c,e,tp)
	return c:IsSetCard(0x7fa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(4) 
end
function c127503.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c127503.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c127503.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c127503.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
