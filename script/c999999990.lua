--传说之法阵
function c999999990.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,999999990+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c999999990.cost)
    e1:SetTarget(c999999990.target)
	e1:SetOperation(c999999990.activate)
	c:RegisterEffect(e1)
end
function c999999990.cfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGrave()
end
function c999999990.filter(c)
	return (c:IsSetCard(0x984) or c:IsSetCard(0x985))  and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c999999990.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return     Duel.IsExistingMatchingCard(c999999990.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c999999990.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g1,REASON_EFFECT)
end
function c999999990.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999990.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999990.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c999999990.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
