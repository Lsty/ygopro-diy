--神葬「虚无结界」
function c14700009.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c14700009.target)
	e1:SetOperation(c14700009.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c14700009.codisable)
	e2:SetCost(c14700009.cost)
	e2:SetTarget(c14700009.rectg)
	e2:SetOperation(c14700009.recop)
	c:RegisterEffect(e2)
end
function c14700009.filter(c)
	return c:IsSetCard(0x147) and c:IsFaceup() and c:IsAbleToDeck()
end
function c14700009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14700009.filter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(c14700009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(c14700009.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14700009.thfilter(c)
	return c:IsSetCard(0x147) and c:GetCode()~=14700009 and c:IsAbleToHand()
end
function c14700009.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c14700009.filter,tp,LOCATION_REMOVED,0,nil)
	local g=Duel.GetMatchingGroup(c14700009.thfilter,tp,LOCATION_DECK,0,nil)
	if tg:GetCount()>0 and g:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:Select(tp,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function c14700009.cfilter(c)
	return c:IsSetCard(0x147) and c:GetCode()~=14700009 and c:IsDiscardable()
end
function c14700009.codisable(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount() and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c14700009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14700009.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c14700009.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c14700009.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c14700009.recop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end