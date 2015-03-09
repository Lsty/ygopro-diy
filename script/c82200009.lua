--元素 火符·火神闪光
function c82200009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCountLimit(1)
	e2:SetCondition(c82200009.reccon)
	e2:SetTarget(c82200009.rectg)
	e2:SetOperation(c82200009.recop)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c82200009.reccon1)
	e3:SetTarget(c82200009.pietg)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x811))
	e4:SetValue(100)
	c:RegisterEffect(e4)
end
function c82200009.cfilter(c)
	return c:IsFaceup() and c:IsCode(82200012)
end
function c82200009.reccon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or r~=REASON_BATTLE then return false end
	local rc=eg:GetFirst()
	return Duel.IsExistingMatchingCard(c82200009.cfilter,tp,LOCATION_SZONE,0,1,nil) and rc:IsControler(tp) and rc:IsSetCard(0x811)
end
function c82200009.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c82200009.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c82200009.cfilter1(c)
	return c:IsFaceup() and c:IsCode(82200014)
end
function c82200009.reccon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82200009.cfilter1,tp,LOCATION_SZONE,0,1,nil)
end
function c82200009.pietg(e,c)
	return c:IsSetCard(0x811)
end