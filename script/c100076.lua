--虹纹骑士长·白统
function c100076.initial_effect(c)
	c:EnableReviveLimit()
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100076.spcon)
	e1:SetOperation(c100076.spop)
	c:RegisterEffect(e1)
	--①
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(85103922,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c100076.descost)
	e2:SetTarget(c100076.destg)
	e2:SetOperation(c100076.desop)
	c:RegisterEffect(e2)
	--②
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100076.negcon)
	e3:SetCost(c100076.negcost)
	e3:SetTarget(c100076.reptg)
	e3:SetOperation(c100076.negop)
	c:RegisterEffect(e3)
end
function c100076.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100076.spfilter,tp,LOCATION_REMOVED,0,3,nil)
end
function c100076.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c100076.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c100076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999803.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c100076.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsAbleToDeckAsCost()
end
function c100076.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsAbleToDeckAsCost()
end
function c100076.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,999999783)==0
	and Duel.IsExistingTarget(c100076.desfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100076.desfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,3,nil)
	if g:GetCount()~=3 then return end
	Duel.SendtoDeck(g,nil,3,REASON_COST)
	Duel.RegisterFlagEffect(tp,999999783,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c100076.filter(c)
	return c:IsAbleToDeck()
end
function c100076.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100076.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c100076.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100076.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100076.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(c100076.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e2:SetProperty(EFFECT_FLAG_OATH)
    e:GetHandler():RegisterEffect(e2)
	end
end
function c100076.splimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0xf70)
end
function c100076.repfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c100076.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c100076.repfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c100076.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,100076)==0
    and Duel.IsExistingTarget(c100076.desfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c100076.desfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,2,nil)
    if g:GetCount()~=2 then return end
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c100076.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c100076.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end