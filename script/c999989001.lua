--猫耳女仆
function c999989001.initial_effect(c)
	--to hand1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999989001,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,999989001+EFFECT_COUNT_CODE_OATH)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999989001.condition)
	e1:SetTarget(c999989001.target)
	e1:SetOperation(c999989001.operation)
	c:RegisterEffect(e1)
	--to hand2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_NAGA+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,999989001+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c999989001.thcon)
	e2:SetTarget(c999989001.thtg)
	e2:SetOperation(c999989001.thop)
	c:RegisterEffect(e2)
end
function c999989001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c999989001.filter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c999989001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c999989001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c999989001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c999989001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
end
function c999989001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999989001.thfilter(c)
	return  c:IsAbleToHand()
end
function c999989001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c999989001.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c999989001.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c999989001.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
end