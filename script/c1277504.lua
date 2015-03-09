--枯竭庭院
function c1277504.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c1277504.discon)
	e1:SetOperation(c1277504.operation)
	c:RegisterEffect(e1)
end
function c1277504.cfilter(c)
	return c:IsFaceup() and c:IsCode(1277503)
end
function c1277504.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c1277504.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c1277504.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,1-tp,LOCATION_HAND,0,nil)
	local opt=o
	if tg:GetCount()>0 and re:GetHandler():IsRelateToEffect(re) then
		opt=Duel.SelectOption(1-tp,aux.Stringid(1277504,0),aux.Stringid(1277504,1))
	elseif tg:GetCount()>0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(1277504,0))
	elseif re:GetHandler():IsRelateToEffect(re) then
		opt=Duel.SelectOption(1-tp,aux.Stringid(1277504,1))+1
	else return end
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local sg=tg:Select(1-tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	else
		Duel.NegateActivation(ev)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end