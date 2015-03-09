--秘封·无间之钟
function c99300011.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c99300011.discon3)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c99300011.discon)
	e2:SetValue(TYPE_TRAP)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c99300011.discon1)
	e3:SetCost(c99300011.cost)
	e3:SetTarget(c99300011.target)
	e3:SetOperation(c99300011.activate)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c99300011.discon2)
	e4:SetCost(c99300011.cost)
	e4:SetTarget(c99300011.target1)
	e4:SetOperation(c99300011.activate1)
	c:RegisterEffect(e4)
end
function c99300011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99300011)==0 end
	Duel.RegisterFlagEffect(tp,99300011,RESET_PHASE+PHASE_END,0,1)
end
function c99300011.discon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND)
end
function c99300011.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and e:GetHandler():IsLocation(LOCATION_SZONE)
end
function c99300011.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x993)
end
function c99300011.discon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and Duel.IsExistingMatchingCard(c99300011.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99300011.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsFacedown() and Duel.GetCurrentChain()==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c99300011.filter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x993) and c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c99300011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>3
		and g:IsExists(c99300011.filter,1,nil,e) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c99300011.filter,1,1,nil,e)
	g:Sub(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:Select(tp,3,3,nil)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99300011.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=4 then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c99300011.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c99300011.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c99300011.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99300011.filter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99300011.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c99300011.activate1(e)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end