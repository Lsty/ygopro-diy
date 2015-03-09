--悲运「大钟婆之火」
function c13130160.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13130160+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c13130160.activate)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c13130160.aclimit)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13130160,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,13130161)
	e3:SetCondition(c13130160.con)
	e3:SetCost(c13130160.cost)
	e3:SetTarget(c13130160.target)
	e3:SetOperation(c13130160.operation)
	c:RegisterEffect(e3)
end
function c13130160.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(c13130160.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c13130160.drop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:GetHandler():GetControler()==tp then return end
	Duel.Hint(HINT_CARD,0,13130160)
	Duel.Damage(1-tp,400,REASON_EFFECT)
end
function c13130160.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c13130160.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xddd)
end
function c13130160.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c13130160.filter,tp,LOCATION_MZONE,0,1,nil) and not re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainNegatable(ev)
end
function c13130160.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13130160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c13130160.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end