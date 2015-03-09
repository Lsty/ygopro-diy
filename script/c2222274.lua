--一年生会
function c2222274.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c2222274.descost)
	e1:SetTarget(c2222274.target)
	e1:SetOperation(c2222274.operation)
	c:RegisterEffect(e1)
end
function c2222274.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa74)
end
function c2222274.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c2222274.cfilter,2,nil) end
	local g=Duel.SelectReleaseGroup(tp,c2222274.cfilter,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c2222274.filter(c)
	return c:IsLevelBelow(3) and c:IsSetCard(0xa74) and c:IsAbleToHand()
end
function c2222274.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222274.filter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK)
end
function c2222274.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2222274.filter,tp,LOCATION_DECK,0,3,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end