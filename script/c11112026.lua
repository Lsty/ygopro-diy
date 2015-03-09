--不屈的狩魂
function c11112026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11112026+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11112026.target)
	e1:SetOperation(c11112026.operation)
	c:RegisterEffect(e1)
end
function c11112026.filter(c)
	return c:IsSetCard(0x15b) and c:IsAbleToHand()
end
function c11112026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local hd=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then hd=hd-1 end
		return hd>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=hd and Duel.IsExistingMatchingCard(c11112026.filter,tp,LOCATION_GRAVE,0,hd,nil)
	end
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local tg=Duel.GetMatchingGroup(c11112026.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,sg:GetCount())
end
function c11112026.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local sct=sg:GetCount()
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	local tg=Duel.GetMatchingGroup(c11112026.filter,tp,LOCATION_GRAVE,0,nil)
	if tg:GetCount()>=sct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sel=tg:Select(tp,sct,sct,nil)
		Duel.SendtoHand(sel,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sel)
		local g=Duel.GetOperatedGroup()
	    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if ct>0 then
		    if ct<=5 then
		        Duel.BreakEffect()
		        Duel.DiscardDeck(tp,ct,REASON_EFFECT)
			else
                Duel.BreakEffect()
		        Duel.DiscardDeck(tp,5,REASON_EFFECT)
			end	
		end	
	end
end