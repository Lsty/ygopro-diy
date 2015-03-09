--黄金鹿与暴风夜
function c999989930.initial_effect(c)  
    c:SetUniqueOnField(1,0,999989930)
	--Activate  
    local e1=Effect.CreateEffect(c)  
    e1:SetType(EFFECT_TYPE_ACTIVATE)  
    e1:SetCode(EVENT_FREE_CHAIN)  
    e1:SetCondition(c999989930.actcon)
    c:RegisterEffect(e1)  
	 --rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c999989930.descon)
	c:RegisterEffect(e2)
	 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999998,5))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c999989930.descost)
	e3:SetTarget(c999989930.destg)
	e3:SetOperation(c999989930.desop)
	c:RegisterEffect(e3)
end
function c999989930.actfilter(c)
	return c:IsFaceup() and c:IsCode(999989924) 
end
function c999989930.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999989930.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c999989930.descon(e)
	return not Duel.IsExistingMatchingCard(c999989930.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c999989930.sgfilter(c)
	return   c:IsType(TYPE_EQUIP) and  c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c999989930.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989930.sgfilter,tp,LOCATION_HAND,0,1,e:GetHandler())  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local ct=Duel.SelectMatchingCard(tp,c999989930.sgfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(ct,REASON_COST+REASON_DISCARD)
end
function c999989930.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c999989930.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc  and  e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup()  then
	Duel.Destroy(tc,REASON_EFFECT)
end
end
