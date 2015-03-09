--百合百合 天然呆花花公子 粢爱丽丝
function c2222291.initial_effect(c)
    c:EnableCounterPermit(0x747)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c2222291.condition)
	e2:SetOperation(c2222291.ctop)
	c:RegisterEffect(e2)
	--atk down2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-500)
	c:RegisterEffect(e3)
	--atk down
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c2222291.val)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetCondition(c2222291.indcon)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c2222291.indcon)
	e6:SetTarget(c2222291.damtg)
	e6:SetOperation(c2222291.damop)
	c:RegisterEffect(e6)
	--disable spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c2222291.splimit)
	c:RegisterEffect(e7)
end
function c2222291.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa74) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c2222291.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c2222291.filter,1,nil,tp)
end
function c2222291.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x747,1)
end
function c2222291.val(e)
	return e:GetHandler():GetCounter(0x747)*-100
end
function c2222291.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1100)
end
function c2222291.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c2222291.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO or bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c2222291.filter4(c)
	return c:IsFaceup() and c:IsCode(2222290)
end
function c2222291.indcon(e,c)
    return Duel.IsExistingMatchingCard(c2222291.filter4,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end