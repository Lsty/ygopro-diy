--VOCALOID-呪音キク
function c79900004.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCondition(c79900004.thcon)
	e1:SetCost(c79900004.thcost)
	e1:SetTarget(c79900004.thtg)
	e1:SetOperation(c79900004.thop)
	c:RegisterEffect(e1)
end
function c79900004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c79900004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,79900004)==0 end
	Duel.RegisterFlagEffect(tp,79900004,RESET_PHASE+PHASE_END,0,1)
end
function c79900004.filter(c)
	return c:IsSetCard(0x799) and c:GetCode()~=79900004 and c:IsAbleToHand()
end
function c79900004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79900004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79900004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetLP(tp)>2000 then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
		end
	end
end