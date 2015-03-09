--剑士 立华奏
function c18725601.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18725601.spcon)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c18725601.efcon)
	e2:SetOperation(c18725601.efop)
	c:RegisterEffect(e2)
end
function c18725601.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x266)
end
function c18725601.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==4 and
		Duel.IsExistingMatchingCard(c18725601.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c18725601.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and re:GetHandler():IsRace(RACE_FAIRY)
end
function c18725601.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c18725601.valcon)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c18725601.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():GetOverlayCount()~=0 and e:GetHandler():IsRace(RACE_FAIRY)
end