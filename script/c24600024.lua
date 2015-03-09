--戏言·军师·萩原子荻
function c24600024.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,24600003,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),1,true,true)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c24600024.negcon)
	e1:SetCost(c24600024.negcost)
	e1:SetTarget(c24600024.negtg)
	e1:SetOperation(c24600024.negop)
	c:RegisterEffect(e1)
end
function c24600024.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x246)
end
function c24600024.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g:IsExists(c24600024.tfilter,1,nil,tp) and re:GetHandler():GetControler()==1-tp
end
function c24600024.ctfilter(c,ty,tp)
	return c:IsType(ty) and c:IsAbleToRemoveAsCost()
end
function c24600024.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ty=re:GetHandler():GetType()
	if chk==0 then return Duel.IsExistingMatchingCard(c24600024.ctfilter,tp,LOCATION_GRAVE,0,1,nil,ty) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c24600024.ctfilter,tp,LOCATION_GRAVE,0,1,1,nil,ty)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c24600024.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c24600024.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end