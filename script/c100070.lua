--虹纹骑士长·灰统
function c100070.initial_effect(c)
    c:SetUniqueOnField(1,1,100070)
    --xyz summon
    aux.AddXyzProcedure(c,nil,5,2,c100070.ovfilter,aux.Stringid(100069,4))
    c:EnableReviveLimit()
	--①
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c100070.atkval)
	c:RegisterEffect(e1)
	--②场上的虹纹不受效果影响
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100070,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c100070.cost)
	e2:SetOperation(c100070.operation)
	c:RegisterEffect(e2)
	--这张卡超量召唤成功的回合结束时才能发动。从卡组把1张「虹纹」卡从游戏中除外。
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c100070.spcon)
    e3:SetOperation(c100070.regop)
    c:RegisterEffect(e3)
end
function c100070.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c100070.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(999999784,1))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetTarget(c100070.target)
    e1:SetOperation(c100070.retop)
    e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function c100070.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsRankBelow(4) and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100070.tgfilter(c)
    return c:IsSetCard(0xf70) and c:IsAbleToRemove()
end
function c100070.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c100070.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c100070.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c100070.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function c100070.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c100070.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsType(TYPE_MONSTER)
end
function c100070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	and Duel.IsExistingMatchingCard(c100070.filter,tp,LOCATION_REMOVED,0,2,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100070.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()~=2 then return end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c100070.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100070.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetValue(c100070.efilter)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c100070.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
