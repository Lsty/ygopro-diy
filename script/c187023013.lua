--強欲で謙虚な壺
function c187023013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c187023013.spcost)
	e1:SetTarget(c187023013.thtg)
	e1:SetOperation(c187023013.thop)
	c:RegisterEffect(e1)
end
function c187023013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,187023013)==0 end
	Duel.RegisterFlagEffect(tp,187023013,RESET_PHASE+PHASE_END,0,1)
end
function c187023013.thfilter(c)
	return c:IsSetCard(0x257) and c:IsAbleToHand()
end
function c187023013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187023013.thfilter,tp,LOCATION_DECK,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c187023013.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c187023013.thfilter,tp,LOCATION_DECK,0,nil,nil)
	if g:GetCount()>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,5,5,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end