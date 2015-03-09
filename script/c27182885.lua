--BF－アーマード·ウィング
function c27182885.initial_effect(c)
	c:SetUniqueOnField(1,0,27182885)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(27182885,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,27182885)
	e2:SetCost(c27182885.thcost)
	e2:SetTarget(c27182885.thtg)
	e2:SetOperation(c27182885.thop)
	c:RegisterEffect(e2)
	--counter1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_REMOVE_COUNTER+0xf)
	e3:SetCountLimit(1,27182886)
	e3:SetOperation(c27182885.ctop1)
	c:RegisterEffect(e3)
	--counter2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(27182885,0))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c27182885.ctcon2)
	e5:SetOperation(c27182885.ctop2)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27182885,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c27182885.cost2)
	e4:SetTarget(c27182885.target)
	e4:SetOperation(c27182885.operation2)
	c:RegisterEffect(e4)
end
function c27182885.filter(c)
	return c:GetCounter(0xf)>0
end
function c27182885.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c27182885.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c27182885.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local c=g:GetFirst()
    local t=c:GetCounter(0xf)
	e:SetLabel(t)
    c:RemoveCounter(tp,0xf,t,REASON_COST)
    --e:GetHandler():AddCounter(0xf,t)
end
function c27182885.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0xf)
end
function c27182885.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0xf,e:GetLabel())
	end
end
function c27182885.ctop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf,1)
end
function c27182885.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0xf)
	e:SetLabel(ct)
	return e:GetHandler():IsReason(REASON_DESTROY) and ct>0
end
function c27182885.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27182885,3))
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0xf,1)
	end
end
function c27182885.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0xf,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0xf,4,REASON_COST)
end
function c27182885.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c27182885.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end