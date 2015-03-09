--魔人 祸灵梦
function c59100009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59100009,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c59100009.negcon)
	e1:SetCost(c59100009.negcost)
	e1:SetTarget(c59100009.negtg)
	e1:SetOperation(c59100009.negop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59100009,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c59100009.cost)
	e2:SetTarget(c59100009.destg)
	e2:SetOperation(c59100009.desop)
	c:RegisterEffect(e2)
end
function c59100009.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c59100009.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,59100003)<=1 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,59100003,RESET_PHASE+PHASE_END,0,1)
end
function c59100009.filter2(c)
	return c:IsFaceup() and (c:GetAttack()~=c:GetBaseAttack() or c:GetDefence()~=c:GetBaseDefence())
end
function c59100009.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c59100009.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c59100009.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	g=Duel.GetMatchingGroup(c59100009.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	tc=g:GetFirst()
	while tc do
		if tc:GetAttack()~=tc:GetBaseAttack() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
		if tc:GetDefence()~=tc:GetBaseDefence() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENCE_FINAL)
			e1:SetValue(tc:GetBaseDefence())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c59100009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,59100003)<=1 end
	Duel.RegisterFlagEffect(tp,59100003,RESET_PHASE+PHASE_END,0,1)
end
function c59100009.desfilter(c,atk,def)
	return c:IsFaceup() and c:IsDestructable() and (c:GetBaseDefence()<def or c:GetBaseAttack()<atk)
end
function c59100009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c59100009.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59100009.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetBaseAttack(),c:GetBaseDefence()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c59100009.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetBaseAttack(),c:GetBaseDefence())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c59100009.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:GetBaseAttack()>=c:GetBaseAttack() and tc:GetBaseDefence()>=c:GetBaseDefence() then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
