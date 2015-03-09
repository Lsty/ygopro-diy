--正太 莉格露
function c27182830.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27182830,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c27182830.addc)
	c:RegisterEffect(e1)
	local e7=e1:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c27182830.ctcon)
	e2:SetOperation(c27182830.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atk down
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c27182830.val)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTarget(c27182830.desreptg)
	e5:SetOperation(c27182830.desrepop)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(27182830,2))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,27182830)
	e6:SetCost(c27182830.thcost)
	e6:SetTarget(c27182830.thtg)
	e6:SetOperation(c27182830.thop)
	c:RegisterEffect(e6)
	--Activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_ACTIVATE)
	e8:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e8)
end
function c27182830.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3dd)
end
function c27182830.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27182830.cfilter,1,nil)
end
function c27182830.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf,1)
end
function c27182830.val(e)
	return e:GetHandler():GetCounter(0xf)*-150
end
function c27182830.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0xf)>=2 end
	return Duel.SelectYesNo(tp,aux.Stringid(27182830,1))
end
function c27182830.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xf,2,REASON_EFFECT)
end
function c27182830.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local ct=Duel.GetMatchingGroupCount(c27182830.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		e:GetHandler():AddCounter(0xf,ct)
	end
end
function c27182830.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xf,2,REASON_COST)
end
function c27182830.filter(c)
	return c:IsSetCard(0x3dd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c27182830.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27182830.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27182830.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27182830.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182830.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end