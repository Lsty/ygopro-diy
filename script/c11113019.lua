--第七小队的决意
function c11113019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11113019+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11113019.cost)
	e1:SetTarget(c11113019.target)
	e1:SetOperation(c11113019.activate)
	c:RegisterEffect(e1)
end
function c11113019.dfilter(c)
    return c:IsSetCard(0x15c) and (bit.band(c:GetType(),0x81)==0x81 or bit.band(c:GetType(),0x82)==0x82)
end	
function c11113019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113019.dfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11113019.dfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function c11113019.filter1(c)
	return c:IsSetCard(0x15c) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c11113019.filter2(c)
	return c:IsSetCard(0x15c) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c11113019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c11113019.filter1,tp,LOCATION_GRAVE,0,1,nil) 
	    and Duel.IsExistingTarget(c11113019.filter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c11113019.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c11113019.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c11113019.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end