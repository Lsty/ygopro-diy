--义妹·艾玛
function c74700200.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74700200,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c74700200.descon)
	e2:SetOperation(c74700200.desop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c74700200.splimit)
	c:RegisterEffect(e3)
end
function c74700200.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_NORMAL) and not c:IsSetCard(0x747) and c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end
function c74700200.cfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_NORMAL) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c74700200.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c74700200.cfilter,1,nil,tp)
end
function c74700200.desop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c74700200.atktg)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE+RESET_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	Duel.RegisterEffect(e2,tp)
end
function c74700200.atktg(e,c)
	return c:IsType(TYPE_NORMAL)
end