--画室的恋人们
function c2222264.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c2222264.target)
	e1:SetOperation(c2222264.operation)
	c:RegisterEffect(e1)
end
function c2222264.filter(c)
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	if c:IsLocation(LOCATION_SZONE) then
		if c:GetSequence()<6 then return false end
	elseif not c:IsType(TYPE_MONSTER) then return false end
	return c:IsSetCard(0xa74) and c:IsAbleToDeck()
end
function c2222264.thfilter(c)
	return c:IsSetCard(0x886) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c2222264.thfilter2(c)
	return c:IsSetCard(0x887) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c2222264.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222264.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,2,nil)
    and Duel.IsExistingMatchingCard(c2222264.thfilter,tp,LOCATION_DECK,0,1,nil)
	and Duel.IsExistingMatchingCard(c2222264.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND)
end
function c2222264.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c2222264.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,2,2,nil)
	local cg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	Duel.ConfirmCards(1-tp,cg)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local g1=Duel.GetMatchingGroup(c2222264.thfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c2222264.thfilter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		end
	end