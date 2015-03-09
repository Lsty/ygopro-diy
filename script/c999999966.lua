--传说之英灵殿
function c999999966.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(999999,12))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c999999966.cost1)
	e2:SetTarget(c999999966.target1)
	e2:SetOperation(c999999966.operation1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(999999,13))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c999999966.cost2)
	e3:SetTarget(c999999966.target2)
	e3:SetOperation(c999999966.operation2)
	c:RegisterEffect(e3)
end
function c999999966.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(999999966)==0
		and Duel.IsExistingMatchingCard(c999999966.filter1,tp,LOCATION_HAND,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(999999966,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c999999966.filter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c999999966.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(999999966)==0
		and Duel.IsExistingMatchingCard(c999999966.filter3,tp,LOCATION_HAND,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(999999966,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c999999966.filter3,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c999999966.filter1(c)
	local tpe=c:GetType()
	return bit.band(tpe,TYPE_SPELL)~=0 and bit.band(tpe,TYPE_CONTINUOUS+TYPE_EQUIP)~=0 and c:IsAbleToDeck()
end
function c999999966.filter2(c)
	return (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and c:IsAbleToHand()
end
function c999999966.filter3(c)
	return c:IsType(TYPE_MONSTER) and  (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and c:IsAbleToDeck()
end
function c999999966.filter4(c)
	return c:IsType(TYPE_MONSTER) and  (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and c:IsAbleToHand()
end
function c999999966.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c999999966.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999966.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c999999966.filter4,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999966.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c999999966.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then  
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g2=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	if g2:GetCount()>0  then  
	Duel.SendtoGrave(g2,REASON_EFFECT+REASON_DISCARD)
end  
end
end
function c999999966.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c999999966.filter4,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0  then
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	if  g1:GetFirst():GetLevel()>4 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g2=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	if g2:GetCount()>0 then  
	Duel.SendtoGrave(g2,REASON_EFFECT+REASON_DISCARD)
end
end
end
end