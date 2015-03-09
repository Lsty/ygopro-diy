--女仆 纱音
function c999989014.initial_effect(c)
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetCondition(c999989014.condition)
	e1:SetCountLimit(1,999989014+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c999989014.setg)
	e1:SetOperation(c999989014.seop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_NAGA+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,999989014+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c999989014.drcon)
	e2:SetTarget(c999989014.drtg)
	e2:SetOperation(c999989014.drop)
	c:RegisterEffect(e2)
end
function c999989014.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c999989014.sefilter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and (c:IsSetCard(0x990) or c:IsSetCard(0xaabb))  and c:IsAbleToHand()
end
function c999989014.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989014.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999989014.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999989014.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c999989014.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999989014.thfilter(c)
	return c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb)  and c:IsAbleToHand() 
end
function c999989014.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989014.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c999989014.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c999989014.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if g:IsRelateToEffect(e)  then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
