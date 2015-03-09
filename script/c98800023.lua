--超越者的领域
function c98800023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c98800023.target)
	e2:SetValue(c98800023.tgvalue)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c98800023.condition)
	e3:SetTarget(c98800023.target1)
	e3:SetOperation(c98800023.operation)
	c:RegisterEffect(e3)
end
function c98800023.target(e,c)
	return c:IsSetCard(0x988) and c:IsType(TYPE_FUSION)
end
function c98800023.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c98800023.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x988) and c:IsType(TYPE_FUSION)
end
function c98800023.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98800023.cfilter,1,nil,tp)
end
function c98800023.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98800023.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end