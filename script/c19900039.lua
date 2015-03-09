--死神RECORD
function c19900039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c19900039.condition)
	e1:SetTarget(c19900039.target)
	e1:SetOperation(c19900039.activate)
	c:RegisterEffect(e1)
end
function c19900039.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x199) and c:IsType(TYPE_SYNCHRO)
end
function c19900039.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return rp~=tp and tg and tg:IsExists(c19900039.cfilter,1,nil)
end
function c19900039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(c19900039.cfilter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c19900039.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	Duel.Destroy(g,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1) then
		Duel.BreakEffect()
		local g1=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
