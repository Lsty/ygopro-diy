--生神停止 铃仙·优昙华院·因幡
function c73700011.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x737),c73700011.ffilter,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c73700011.descon)
	e1:SetValue(c73700011.aclimit3)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c73700011.addcc)
	e2:SetOperation(c73700011.actlimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTarget(c73700011.tg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(c73700011.tglimit)
	c:RegisterEffect(e4)
end
function c73700011.ffilter(c)
	return c:GetAttack()>=2000
end
function c73700011.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(73700011)>0
end
function c73700011.aclimit3(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c73700011.addcc(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c73700011.actlimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c73700011.checkop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c73700011.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(73700011,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c73700011.tg(e,c)
	return c~=e:GetHandler()
end
function c73700011.tglimit(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end