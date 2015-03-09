--元素 土符·三石塔的震动
function c82200014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetCondition(c82200014.condition)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x811))
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c82200014.codisable)
	e3:SetCost(c82200014.descost)
	e3:SetTarget(c82200014.tgdisable)
	e3:SetOperation(c82200014.opdisable)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x811))
	e4:SetValue(100)
	c:RegisterEffect(e4)
end
function c82200014.cfilter(c)
	return c:IsFaceup() and c:IsCode(82200010)
end
function c82200014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82200014.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c82200014.cfilter1(c)
	return c:IsFaceup() and c:IsCode(82200013)
end
function c82200014.codisable(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c82200014.cfilter1,tp,LOCATION_SZONE,0,1,nil)
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c82200014.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c82200014.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c82200014.opdisable(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end