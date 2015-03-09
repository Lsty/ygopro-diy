--梦日记-流浪子
function c75500008.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1)
	e1:SetCondition(c75500008.setcon)
	e1:SetTarget(c75500008.settg)
	e1:SetOperation(c75500008.setop)
	c:RegisterEffect(e1)
end
function c75500008.setcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c75500008.filter(c)
	return c:IsSetCard(0x755) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75500008.filter1(c)
	return c:IsSetCard(0x755) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToHand()
end
function c75500008.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function c75500008.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local sg=g:GetFirst()
	if not sg:IsLocation(LOCATION_GRAVE) then return end
	if sg:IsType(TYPE_MONSTER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75500008.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75500008.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end