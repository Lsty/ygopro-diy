--神天龙王-太虚龙
function c9991217.initial_effect(c)
	--Fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xfff),3,true)
	--Active Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9991217.con)
	e1:SetOperation(c9991217.actlimit)
	c:RegisterEffect(e1)
	--Power Up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991217,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9991217.con)
	e2:SetOperation(c9991217.op)
	c:RegisterEffect(e2)
	--Summon Limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c9991217.sumsuc)
	c:RegisterEffect(e3)
	--Side Effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
end
function c9991217.actlimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9991217.con(e,tp,eg,ep,ev,re,r,rp)
	local mat=e:GetHandler():GetMaterial() local tc=mat:GetFirst() ck=0
	while tc do if bit.band(tc:GetOriginalType(),TYPE_FUSION)>0 then ck=1 end tc=mat:GetNext() end
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and ck==1
end
function c9991217.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM)
end
function c9991217.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=Duel.GetMatchingGroupCount(c9991217.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*300
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9991217.ftarget)
	e2:SetLabel(c:GetFieldID())
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c9991217.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c9991217.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9991217.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9991217.sumlimit(e,c,sump,sumtype,sumpos,targetp,sumtp)
	return c:IsSetCard(0xfff) and bit.band(c:GetOriginalType(),TYPE_FUSION)>0
end
