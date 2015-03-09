--六根财净 鬼巫女
function c59100012.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c59100012.negcon)
	e1:SetCost(c59100012.negcost)
	e1:SetTarget(c59100012.negtg)
	e1:SetOperation(c59100012.negop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c59100012.thcon)
	e2:SetCost(c59100012.cost)
	e2:SetTarget(c59100012.thtg)
	e2:SetOperation(c59100012.thop)
	c:RegisterEffect(e2)
end
function c59100012.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c59100012.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,59100002)<=1 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,59100002,RESET_PHASE+PHASE_END,0,1)
end
function c59100012.filter(c)
	return c:IsFaceup() and (c:GetBaseAttack()>0 or c:GetBaseDefence()>0)
end
function c59100012.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c59100012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59100012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c59100012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c59100012.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and (tc:GetBaseAttack()>0 or tc:GetBaseDefence()>0) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetBaseAttack()/2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENCE)
		e2:SetValue(tc:GetBaseDefence()/2)
		tc:RegisterEffect(e2)
	end
end
function c59100012.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c59100012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,59100002)<=1 end
	Duel.RegisterFlagEffect(tp,59100002,RESET_PHASE+PHASE_END,0,1)
end
function c59100012.filter1(c,atk)
	return c:IsFaceup() and c:GetBaseAttack()<atk and c:IsAbleToGrave()
end
function c59100012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59100012.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler():GetBaseAttack()) end
	local g=Duel.GetMatchingGroup(c59100012.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler():GetBaseAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c59100012.thop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c59100012.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler():GetBaseAttack())
	Duel.SendtoGrave(g,REASON_EFFECT)
end