--旧时代的象征 古塔
function c11112023.initial_effect(c)
    c:EnableCounterPermit(0xfa)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c11112023.acop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15b))
	e3:SetValue(c11112023.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c11112023.destg)
	e5:SetValue(c11112023.value)
	e5:SetOperation(c11112023.desop)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetDescription(aux.Stringid(11112023,1))
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c11112023.thcon)
	e6:SetTarget(c11112023.thtg)
	e6:SetOperation(c11112023.thop)
	c:RegisterEffect(e6)
end
function c11112023.atkval(e,c)
	return e:GetHandler():GetCounter(0xfa)*100
end
function c11112023.cfilter(c,tp)
	return c:GetPreviousLocation()==LOCATION_DECK and c:GetPreviousControler()==tp
end
function c11112023.acop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c11112023.cfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0xfa,1)
	end
end	
function c11112023.dfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
		and c:IsSetCard(0x15b) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c11112023.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c11112023.dfilter,nil,tp)
		e:SetLabel(count)
		return count>0 and e:GetHandler():GetCounter(0xfa)>=count*2
	end
	return Duel.SelectYesNo(tp,aux.Stringid(11112023,0))
end
function c11112023.value(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
		and c:IsSetCard(0x15b) and c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_EFFECT)
end
function c11112023.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	e:GetHandler():RemoveCounter(ep,0xfa,count*2,REASON_EFFECT)
end
function c11112023.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0xfa)
	e:SetLabel(ct)
	return ct>0 and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_DESTROY)
end
function c11112023.thfilter(c,lv)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x15b) and c:IsAbleToHand()
end
function c11112023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11112023.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11112023.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11112023.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end	