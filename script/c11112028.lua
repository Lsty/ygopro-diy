--反击的怒火
function c11112028.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c11112028.condition1)
	e1:SetCost(c11112028.cost)
	e1:SetTarget(c11112028.target1)
	e1:SetOperation(c11112028.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	--Activate(effect)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c11112028.condition2)
	e3:SetCost(c11112028.cost)
	e3:SetTarget(c11112028.target2)
	e3:SetOperation(c11112028.activate2)
	c:RegisterEffect(e3)
end
function c11112028.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15b) and c:IsLevelAbove(7) and c:IsType(TYPE_SYNCHRO)
end
function c11112028.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsExistingMatchingCard(c11112028.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11112028.dfilter(c)
	return c:IsSetCard(0x15b) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c11112028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11112028.dfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c11112028.dfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c11112028.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c11112028.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
end
function c11112028.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) 
	    and Duel.IsExistingMatchingCard(c11112028.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11112028.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c11112028.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end