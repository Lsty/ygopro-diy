--妖精 立华奏
function c18725608.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(89258906,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_MULTIACT_HAND+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c18725608.condition)
	e1:SetCost(c18725608.spcost)
	e1:SetTarget(c18725608.target)
	e1:SetOperation(c18725608.operation)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c18725608.efcon)
	e2:SetOperation(c18725608.efop)
	c:RegisterEffect(e2)
end
function c18725608.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,18725608)==0 end
	Duel.RegisterFlagEffect(tp,18725608,RESET_PHASE+PHASE_END,0,1)
end
function c18725608.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c18725608.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c18725608.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c18725608.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and re:GetHandler():IsRace(RACE_FAIRY)
end
function c18725608.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRace(RACE_FAIRY)
end
function c18725608.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetCondition(c18725608.matcon)
	e1:SetValue(rc:GetAttack()/2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	rc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetCondition(c18725608.matcon)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	rc:RegisterEffect(e2)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_TYPE)
		e3:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e3)
	end
end