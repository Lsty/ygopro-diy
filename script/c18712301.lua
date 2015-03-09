--1
function c18712301.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c18712301.splimit)
	c:RegisterEffect(e1)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c18712301.target)
	e3:SetOperation(c18712301.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69000994,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCountLimit(1,18712301)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_RECOVER)
	e1:SetCondition(c18712301.cd)
	e1:SetCost(c18712301.cost)
	e1:SetOperation(c18712301.unop)
	c:RegisterEffect(e1)
	--Attribute Dark
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
end
function c18712301.mat_check(c)
    return not c:IsCode(111111)
end
function c18712301.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
	e:GetHandler():RegisterEffect(e1)
end
function c18712301.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c18712301.cd(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep
end
function c18712301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c18712301.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c18712301.unop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	--local sc=sg:GetFirst()
	--if sc:IsType(TYPE_MONSTER) then
	--local e1=Effect.CreateEffect(e:GetHandler())
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	--e1:SetTargetRange(1,1)
	--e1:SetValue(c18712301.aclimit1)
	--e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	--Duel.RegisterEffect(e1,tp)
	--elseif sc:IsType(TYPE_SPELL) then
	--local e1=Effect.CreateEffect(e:GetHandler())
--	e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	--e1:SetTargetRange(1,1)
	--e1:SetValue(c18712301.aclimit2)
	--e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	--Duel.RegisterEffect(e1,tp)
	--else
	--local e1=Effect.CreateEffect(e:GetHandler())
	---e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetCode(EFFECT_CANNOT_ACTIVATE)
--	e1:SetTargetRange(1,1)
	--e1:SetValue(c18712301.aclimit3)
	--e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
--	Duel.RegisterEffect(e1,tp)
--	end
end
function c18712301.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c18712301.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not re:GetHandler():IsImmuneToEffect(e)
end
function c18712301.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end