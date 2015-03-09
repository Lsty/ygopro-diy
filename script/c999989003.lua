--女仆 翡翠
function c999989003.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999989003,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,999989003+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c999989003.condition)
	e1:SetTarget(c999989003.target)
	e1:SetOperation(c999989003.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_NAGA)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,999989003+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c999989003.secon)
	e2:SetTarget(c999989003.setg)
	e2:SetOperation(c999989003.seop)
	c:RegisterEffect(e2)
end
function c999989003.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c999989003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,999989003)==0  end
	Duel.RegisterFlagEffect(tp,999989003,RESET_PHASE+PHASE_END,0,1)
end
function c999989003.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c999989003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c999989003.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999989003.dfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c999989003.dfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c999989003.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
end
end
function c999989003.secon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999989003.filter(c)
	return  (c:IsSetCard(0x990) or c:IsSetCard(0xaabb)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c999989003.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c999989003.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c999989003.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c999989003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end