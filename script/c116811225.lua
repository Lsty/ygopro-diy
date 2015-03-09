--镜世录 年幼之狼
function c116811225.initial_effect(c)
	--send 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(116811225,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,116811225)
	e1:SetCondition(c116811225.recon)
	e1:SetTarget(c116811225.rectg)
	e1:SetOperation(c116811225.recop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e2))
	e2:SetValue(300)
	c:RegisterEffect(e2)
end
function c116811225.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c116811225.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:GetLocation()==LOCATION_GRAVE end
end
function c116811225.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetLocation()~=LOCATION_GRAVE then return false end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	c:RegisterFlagEffect(116811225,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
end