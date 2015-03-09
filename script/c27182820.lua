--暗夜的妖怪 莉格露
function c27182820.initial_effect(c)
	c:SetUniqueOnField(1,0,27182820)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c27182820.sdcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27182820,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c27182820.costd2)
	e3:SetTarget(c27182820.tgd2)
	e3:SetOperation(c27182820.opd2)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_DESTROY)
	e4:SetCondition(c27182820.ctcon)
	e4:SetOperation(c27182820.ctop)
	c:RegisterEffect(e4)
end
function c27182820.sdcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENCE)
end
function c27182820.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3dd) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c27182820.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27182820.ctfilter,1,nil,tp)
end
function c27182820.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf,1)
end
function c27182820.costd2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(e:GetHandler():GetCounter(0xf)*500)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c27182820.tgd2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0xf)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c27182820.opd2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end