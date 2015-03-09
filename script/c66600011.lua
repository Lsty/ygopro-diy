--缠剑之魔姬
function c66600011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c66600011.xyzfilter,4,2)
	c:EnableReviveLimit()
	--DIRECT ATTACK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c66600011.cost)
	e1:SetCondition(c66600011.con)
	e1:SetOperation(c66600011.op)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c66600011.ccost)
	e2:SetTarget(c66600011.target)
	e2:SetOperation(c66600011.operation)
	c:RegisterEffect(e2)
end
function c66600011.xyzfilter(c)
	return c:IsSetCard(0x666) or c:IsRace(RACE_WARRIOR)
end
function c66600011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,66600011)==0 end
	Duel.RegisterFlagEffect(tp,66600011,RESET_PHASE+PHASE_END,0,1)
end
function c66600011.con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c66600011.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c66600011.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,66600011)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.RegisterFlagEffect(tp,66600011,RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66600011.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c66600011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66600011.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66600011.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c66600011.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66600011.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end