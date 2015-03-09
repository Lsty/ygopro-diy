--月之妖鸟 宇佐见莲子
function c99300012.initial_effect(c)
	c:SetUniqueOnField(1,0,99300007)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(99300007)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c99300012.spcon)
	e2:SetOperation(c99300012.operation1)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99300012.setcon)
	e3:SetTarget(c99300012.settg)
	e3:SetOperation(c99300012.setop)
	c:RegisterEffect(e3)
end
function c99300012.spfilter(c)
	return c:IsCode(99300009)
end
function c99300012.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-1 then return false end
	if ft<=0 then
		return Duel.IsExistingMatchingCard(c99300012.spfilter,tp,LOCATION_MZONE,0,1,nil)
	else return Duel.IsExistingMatchingCard(c99300012.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
end
function c99300012.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		local g1=Duel.SelectMatchingCard(tp,c99300012.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoDeck(g1,nil,2,REASON_COST)
	else
		local g1=Duel.SelectMatchingCard(tp,c99300012.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoDeck(g1,nil,2,REASON_COST)
	end
end
function c99300012.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and re:GetHandler():IsSetCard(0x993)
end
function c99300012.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup()
		and not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99300012.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end