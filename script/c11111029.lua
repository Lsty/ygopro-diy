--温雅之花 怜舟·幸
function c11111029.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),3,2)
	c:EnableReviveLimit()
	--ret&draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111029,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11111029.cost)
	e1:SetTarget(c11111029.target)
	e1:SetOperation(c11111029.operation)
	c:RegisterEffect(e1)
end
function c11111029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11111029.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToDeck()
end
function c11111029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11111029.filter1(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c11111029.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c11111029.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11111029.tgfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c11111029.cfilter(c,e)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function c11111029.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelBelow(3) and c:IsAbleToHand()
end
function c11111029.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:IsExists(c11111029.tgfilter,1,nil,e) then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c11111029.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) then
	   local g=Duel.GetMatchingGroup(c11111029.sfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11111029,1)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local sg=g:Select(tp,1,1,nil)
		  Duel.SendtoHand(sg,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,sg)
		end
	end	
end