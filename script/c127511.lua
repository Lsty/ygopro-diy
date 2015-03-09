--时幻诡术师 艾霍特
function c127511.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,127511)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c127511.discon)
	e1:SetOperation(c127511.operation)
	c:RegisterEffect(e1)
end
function c127511.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7fa) and c:IsType(TYPE_MONSTER)
end
function c127511.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c127511.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c127511.tfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c127511.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(c127511.tfilter,1-tp,LOCATION_HAND,0,nil)
	local opt=o
	if tg:GetCount()>0 and re:GetHandler():IsRelateToEffect(re) then
		opt=Duel.SelectOption(1-tp,aux.Stringid(127511,1),aux.Stringid(127511,2))
	elseif tg:GetCount()>0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(127511,1))
	elseif re:GetHandler():IsRelateToEffect(re) then
		opt=Duel.SelectOption(1-tp,aux.Stringid(127511,2))+1
	else return end
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local sg=tg:Select(1-tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	else
		Duel.NegateActivation(ev)
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
