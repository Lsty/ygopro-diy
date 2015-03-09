--化猫之幻 玛艾露贝莉·赫恩
function c99300013.initial_effect(c)
	c:SetUniqueOnField(1,0,99300009)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(99300009)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c99300013.spcon)
	e2:SetOperation(c99300013.operation1)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99300013.setcon)
	e3:SetTarget(c99300013.settg)
	e3:SetOperation(c99300013.setop)
	c:RegisterEffect(e3)
end
function c99300013.spfilter(c)
	return c:IsCode(99300007)
end
function c99300013.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-1 then return false end
	if ft<=0 then
		return Duel.IsExistingMatchingCard(c99300013.spfilter,tp,LOCATION_MZONE,0,1,nil)
	else return Duel.IsExistingMatchingCard(c99300013.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
end
function c99300013.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		local g1=Duel.SelectMatchingCard(tp,c99300013.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoDeck(g1,nil,2,REASON_COST)
	else
		local g1=Duel.SelectMatchingCard(tp,c99300013.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoDeck(g1,nil,2,REASON_COST)
	end
end
function c99300013.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and re:GetHandler():IsSetCard(0x993)
end
function c99300013.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c99300013.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99300013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c99300013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99300013.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c99300013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end