--眼镜女仆
function c999989000.initial_effect(c)
	--change pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11613567,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c999989000.chtg)
	e1:SetOperation(c999989000.chop)
	c:RegisterEffect(e1)
    --search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCountLimit(1,999989000+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c999989000.condition)
	e2:SetTarget(c999989000.setg)
	e2:SetOperation(c999989000.seop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CAED_TARGET)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,999989000+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c999989000.thcon)
	e3:SetTarget(c999989000.thtg)
	e3:SetOperation(c999989000.thop)
	c:RegisterEffect(e3)
end
function c999989000.chfilter(c)
	return c:IsFaceup()
end
function c999989000.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and  c999989000.chfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999989000.chfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c999989000.chfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c999989000.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,0)
	end
end
function c999989000.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c999989000.sefilter(c)
	return (c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb)) and c:IsAbleToHand() and  c:IsType(TYPE_MONSTER) and not c:IsCode(999989000)
end
function c999989000.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989000.sefilter,tp,LOCATION_DECK,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999989000.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999989000.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c999989000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999989000.thfilter(c)
	return c:IsSetCard(0x990) and c:IsAbleToHand() and  c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c999989000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989000.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c999989000.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c999989000.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if g:IsRelateToEffect(e)  then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
