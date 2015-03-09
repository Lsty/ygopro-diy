--圣女 秀吉
function c187199005.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13532663,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c187199005.condition)
	e1:SetTarget(c187199005.target)
	e1:SetOperation(c187199005.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91133740,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FLIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c187199005.spcon)
	e1:SetTarget(c187199005.destg)
	e1:SetOperation(c187199005.desop)
	c:RegisterEffect(e1)
end
function c187199005.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE and Duel.GetTurnPlayer()~=tp
end
function c187199005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetEnvironment()==187199010
end
function c187199005.filter(c)
	return c:IsAbleToChangeControler() and c:IsFaceup() and c:IsAttackPos() and c:IsType(TYPE_MONSTER)
end
function c187199005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c187199005.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,c187199005.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g2,2,0,0)
end
function c187199005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local c2=g:GetFirst()
	Duel.ChangePosition(c,POS_FACEDOWN_DEFENCE)
	if Duel.SwapControl(c,c2,0,0) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		c2:RegisterEffect(e2)
end
end
function c187199005.dfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c187199005.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c187199005.dfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c187199005.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c187199005.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end