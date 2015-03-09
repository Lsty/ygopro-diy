--时符·雕刻红色灵魂
function c98700013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c98700013.condition)
	e1:SetCost(c98700013.cost)
	e1:SetTarget(c98700013.target)
	e1:SetOperation(c98700013.activate)
	c:RegisterEffect(e1)
end
function c98700013.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c98700013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98700013)==0 and Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x987) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x987)
	Duel.Release(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,98700013,RESET_PHASE+PHASE_END,0,1)
end
function c98700013.filter(c)
	return c:IsFaceup() and not c:IsDisabled() and not c:IsType(TYPE_NORMAL)
end
function c98700013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c98700013.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98700013.filter,tp,0,LOCATION_ONFIELD,1,nil)
		and (Duel.GetCurrentChain()<1 or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c98700013.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if Duel.GetCurrentChain()>=2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c98700013.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
	end
	local ct=Duel.GetCurrentChain()
	if ct>=2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end