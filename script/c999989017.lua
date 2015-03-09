--武装女仆 UNKNOWN
function c999989017.initial_effect(c)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999989003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetCondition(c999989017.condition)
	e1:SetOperation(c999989017.operation)
	c:RegisterEffect(e1)
	--xyz limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c999989017.xyzlimit)
	e2:SetOperation(c999989017.xyzop)
	c:RegisterEffect(e2)
	--immnue
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_NAGA+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,999989017+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c999989017.imcon)
	e3:SetTarget(c999989017.imtg)
	e3:SetOperation(c999989017.imop)
	c:RegisterEffect(e3)
end
function c999989017.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c999989017.operation(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(c999989017.checkop)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,0)
end
function c999989017.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
    if tc:IsSetCard(0x990) and tc:IsType(TYPE_XYZ) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetCondition(c999989017.tgcon)
	e1:SetValue(c999989017.tglimit)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
end
end
function c999989017.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()~=0 
end
function c999989017.tglimit(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c999989017.xyzlimit(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) 
end
function c999989017.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	    e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
end
function c999989017.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999989017.imfilter(c)
	return c:IsFaceup() and  c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb)
end 
function c999989017.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c999989017.imfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999989017.imfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c999989017.imfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c999989017.imop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetCode(EFFECT_IMMUNE_EFFECT)
	    e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c999989017.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c999989017.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and e:GetHandlerPlayer()~=te:GetHandlerPlayer()
end