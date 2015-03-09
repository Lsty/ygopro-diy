--虹纹之领主
function c999999799.initial_effect(c)
    c:SetUniqueOnField(1,1,999999799)
	--超量召唤
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xf70),4,2,c999999799.ovfilter,aux.Stringid(100069,3),5)
	c:EnableReviveLimit()
	--①
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c999999799.atkval)
	c:RegisterEffect(e1)
	--②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100069,5))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c999999799.discon)
	e2:SetCost(c999999799.discost)
	e2:SetTarget(c999999799.distg)
	e2:SetOperation(c999999799.disop)
	c:RegisterEffect(e2)
	 --这张卡同调召唤成功的回合结束时才能发动。从卡组把1张「虹纹」卡从游戏中除外。
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c999999799.spcon)
    e3:SetOperation(c999999799.regop)
    c:RegisterEffect(e3)
end
function c999999799.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c999999799.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(999999784,1))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetTarget(c999999799.target)
    e1:SetOperation(c999999799.retop)
    e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function c999999799.tgfilter(c)
    return c:IsSetCard(0xf70) and c:IsAbleToRemove()
end
function c999999799.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c999999799.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c999999799.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c999999799.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function c999999799.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:GetCode()~=999999799 and c:IsType(TYPE_XYZ)
end
function c999999799.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c999999799.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c999999799.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsAbleToDeckAsCost()
end
function c999999799.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	and Duel.IsExistingMatchingCard(c999999799.filter,tp,LOCATION_REMOVED,0,2,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c999999799.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()~=2 then return end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c999999799.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c999999799.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.BreakEffect()
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end