--秘剑·燕返！
function c999999978.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,999999978+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c999999978.condition)
	e1:SetTarget(c999999978.target)
	e1:SetOperation(c999999978.operation)
	c:RegisterEffect(e1)
	if not c999999978.global_check then
		c999999978.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c999999978.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c999999978.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsCode(999999978) then
		Duel.RegisterFlagEffect(tc:GetControler(),999999978,RESET_PHASE+PHASE_END,0,1)
	end
end
function c999999978.cfilter(c)
	return c:IsFaceup() and c:IsCode(999999988)
end
function c999999978.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999999978.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c999999978.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c999999978.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c999999978.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999978.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c999999978.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c999999978.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
