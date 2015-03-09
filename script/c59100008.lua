--杀意的分身 祸灵梦
function c59100008.initial_effect(c)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c59100008.cost)
	e1:SetTarget(c59100008.target)
	e1:SetOperation(c59100008.operation)
	c:RegisterEffect(e1)
end
function c59100008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,59100003)<=1
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,59100003,RESET_PHASE+PHASE_END,0,1)
end
function c59100008.filter(c,atk,def)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and (c:GetBaseDefence()<def or c:GetBaseAttack()<atk)
end
function c59100008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(c59100008.filter,tp,0,LOCATION_MZONE,1,nil,c:GetBaseAttack(),c:GetBaseDefence()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c59100008.filter,tp,0,LOCATION_MZONE,1,1,nil,c:GetBaseAttack(),c:GetBaseDefence())
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c59100008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:GetBaseAttack()>=c:GetBaseAttack() and tc:GetBaseDefence()>=c:GetBaseDefence() then return end
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
