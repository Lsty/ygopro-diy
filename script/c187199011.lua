--萨蒂娅
function c187199011.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,187199009,c187199011.ffilter,1,true,true)
	--level change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36088082,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c187199011.regcon)
	e1:SetTarget(c187199011.regtg)
	e1:SetOperation(c187199011.regop)
	c:RegisterEffect(e1)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,187199011)
	e4:SetCondition(c187199011.condition)
	e4:SetCost(c187199011.spcost)
	e4:SetTarget(c187199011.target)
	e4:SetOperation(c187199011.activate)
	c:RegisterEffect(e4)
end
function c187199011.ffilter(c)
	return c:IsSetCard(0x3e1)
end
function c187199011.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget() 
	and Duel.GetAttackTarget():IsDefencePos() and Duel.GetAttackTarget():IsAbleToRemove() and Duel.GetAttackTarget():IsFacedown()
end
function c187199011.filter1(c)
	return not c:IsAttackPos() and c:IsAbleToRemove()
end
function c187199011.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c187199011.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c187199011.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c187199011.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c187199011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c187199011.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3e1) and c:IsAbleToDeckAsCost()
end
function c187199011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187199011.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c187199011.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c187199011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c187199011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end