--少女守護
function c18799994.initial_effect(c)  
    c:SetUniqueOnField(1,0,18799994)
	--Activate  
    local e1=Effect.CreateEffect(c)  
    e1:SetType(EFFECT_TYPE_ACTIVATE)  
    e1:SetCode(EVENT_FREE_CHAIN)  
    e1:SetCondition(c18799994.actcon)
	e1:SetTarget(c18799994.acttg)
	e1:SetOperation(c18799994.actop)
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c18799994.descon)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,18799991))
	e3:SetValue(aux.TargetBoolFunction(Card.IsSetCard,0xabb))
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
function c18799994.actfilter(c)
	return c:IsFaceup() and c:IsCode(18799991) 
end
function c18799994.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c18799994.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18799994.tdfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xabb) and c:IsAbleToDeck()
end
function c18799994.tdfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xabb) and c:IsAbleToHand()
end
function c18799994.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18799994.tdfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18799994.tdfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c18799994.tdfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE+CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c18799994.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	local g1=Duel.GetMatchingGroup(c18799994.tdfilter1,tp,LOCATION_GRAVE,0,nil)
	if g1==0 then end
		Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	end
end
function c18799994.descon(e)
	return not Duel.IsExistingMatchingCard(c18799994.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end