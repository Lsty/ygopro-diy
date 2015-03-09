--笨蛋试验召唤大会
function c23300015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c23300015.tg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c23300015.tg)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(23300015)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c23300015.condition)
	e4:SetOperation(c23300015.operation)
	c:RegisterEffect(e4)
end
function c23300015.tg(e,c)
	return c:IsSetCard(0x233) or c:IsSetCard(0x256)
end
function c23300015.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT) and (c:IsSetCard(0x233) or c:IsSetCard(0x256))
end
function c23300015.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23300015.cfilter,1,nil,tp)
end
function c23300015.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
