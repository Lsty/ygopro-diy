--胁迫幻觉 铃仙·优昙华院·因幡
function c73700010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x737),c73700010.ffilter,true)
	--Disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c73700010.condition)
	e1:SetOperation(c73700010.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c73700010.descon)
	e2:SetTarget(c73700010.etarget)
	e2:SetValue(c73700010.efilter)
	c:RegisterEffect(e2)
end
function c73700010.ffilter(c)
	return c:IsRace(RACE_BEAST) and c:IsType(TYPE_FUSION)
end
function c73700010.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	if a:GetControler()==tp then
		e:SetLabelObject(c)
		return c and c:IsType(TYPE_EFFECT) and c:IsRelateToBattle() and a and a:IsSetCard(0x737) and a:IsRelateToBattle()
	else
		e:SetLabelObject(a)
		return a and a:IsType(TYPE_EFFECT) and a:IsRelateToBattle() and c and c:IsSetCard(0x737) and c:IsRelateToBattle()
	end
end
function c73700010.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToBattle() then return end
	Duel.Hint(HINT_CARD,0,73700010)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x57a0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x57a0000)
	tc:RegisterEffect(e2)
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c73700010.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c73700010.etarget(e,c)
	return c:IsSetCard(0x737)
end
function c73700010.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end