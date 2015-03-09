--无限剑制
function c999999982.initial_effect(c)  
    c:SetUniqueOnField(1,0,999999982)
	--Activate  
    local e1=Effect.CreateEffect(c)  
    e1:SetType(EFFECT_TYPE_ACTIVATE)  
    e1:SetCode(EVENT_FREE_CHAIN)  
    e1:SetCondition(c999999982.actcon)
	e1:SetTarget(c999999982.acttg)
	e1:SetOperation(c999999982.actop)
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c999999982.descon)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999,7))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c999999982.target)
	e3:SetOperation(c999999982.operation)
	c:RegisterEffect(e3)
end
function c999999982.actfilter(c)
	return c:IsFaceup() and c:IsCode(999999987) 
end
function c999999982.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999999982.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c999999982.tdfilter1(c)
	return c:IsType(TYPE_EQUIP)  and c:IsAbleToDeck()
end
function c999999982.tdfilter2(c)
	return c:IsType(TYPE_MONSTER)  
end
function c999999982.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c999999982.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroupCount(c999999982.tdfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroupCount(c999999982.tdfilter2,tp,LOCATION_GRAVE,0,nil)
	local tc=Duel.SelectMatchingCard(tp,c999999982.tdfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,g2,nil)
	if g1==0 or g2==0 then end
	if tc:GetCount()>0 then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c999999982.descon(e)
	return not Duel.IsExistingMatchingCard(c999999982.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c999999982.sefilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand() and c:IsSetCard(0x234)
end
function c999999982.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999982.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999982.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.SelectMatchingCard(tp,c999999982.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end