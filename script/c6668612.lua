--天地『俯瞰世界的遥远的大地啊』
function c6668612.initial_effect(c)
		Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:SetUniqueOnField(1,0,6668612)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c6668612.target)
	c:RegisterEffect(e1)
	--Pos Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-800)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
	--tograve
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_SELF_TOGRAVE)
	e5:SetCondition(c6668612.sdcon)
	c:RegisterEffect(e5)
		--negate
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(c6668612.negcon)
	e6:SetCost(c6668612.negcost)
	e6:SetTarget(c6668612.negtg)
	e6:SetOperation(c6668612.negop)
	c:RegisterEffect(e6)
end
function c6668612.sdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x740) and c:IsType(TYPE_MONSTER)
end
function c6668612.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c6668612.descon)
	e1:SetOperation(c6668612.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function c6668612.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c6668612.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c6668612.sdcon(e)
	return not Duel.IsExistingMatchingCard(c6668612.sdfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c6668612.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x740) and c:IsLocation(LOCATION_MZONE)
end
function c6668612.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c6668612.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c6668612.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c6668612.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c6668612.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end