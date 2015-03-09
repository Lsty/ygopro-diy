--幻象的馈赠
function c24094682.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c24094682.cost)
	e1:SetTarget(c24094682.target)
	e1:SetOperation(c24094682.activate)
	c:RegisterEffect(e1)
end
function c24094682.filter(c)
	return c:IsType(TYPE_NORMAL) and c:IsDiscardable()
end
function c24094682.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c24094682.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24094682.filter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c24094682.filter,2,2,REASON_COST+REASON_DISCARD)
end
function c24094682.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24094682.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c24094682.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c24094682.tgfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end