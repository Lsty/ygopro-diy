--时幻咒术师 伊波·兹特尔
function c127506.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,127506)
	e2:SetCondition(c127506.condition)
	e2:SetTarget(c127506.target)
	e2:SetOperation(c127506.operation)
	c:RegisterEffect(e2)
end
function c127506.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7fa) and c:IsType(TYPE_MONSTER)
end
function c127506.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return Duel.IsExistingMatchingCard(c127506.cfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsControler(tp) 
	and tc:IsLocation(LOCATION_ONFIELD) and tc:IsFaceup() and tc:IsSetCard(0x7fa) 
end
function c127506.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c127506.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
