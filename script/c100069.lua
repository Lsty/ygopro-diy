--虹纹之君主
function c100069.initial_effect(c)
	--超量召唤
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xf70),4,2)
	c:EnableReviveLimit()
	--①直到下次的对方的结束阶段时上升除外区「虹纹」怪兽数量×100的数值。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(100069,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100069.cost)
	e1:SetOperation(c100069.operation)
	c:RegisterEffect(e1)
	--②不会被战破不会被卡的效果破坏
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100069,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c100069.discost)
	e2:SetOperation(c100069.disop)
	c:RegisterEffect(e2)
	--这张卡超量召唤成功的回合结束时才能发动。从卡组把1张「虹纹」卡从游戏中除外。
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c100069.spcon)
    e3:SetOperation(c100069.regop)
    c:RegisterEffect(e3)
end
function c100069.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100069.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	    local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetCode(EFFECT_UPDATE_ATTACK)
	    e1:SetValue(c100069.atkval)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
	    c:RegisterEffect(e1)
	end
end
function c100069.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsType(TYPE_MONSTER)
end
function c100069.atkval(e,c)
	return Duel.GetMatchingGroupCount(c100069.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*100
end
function c100069.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c100069.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100069,1))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetTarget(c100069.target)
    e1:SetOperation(c100069.retop)
    e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function c100069.tgfilter(c)
    return c:IsSetCard(0xf70) and c:IsAbleToRemove()
end
function c100069.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c100069.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c100069.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c100069.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function c100069.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsAbleToDeckAsCost()
end
function c100069.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	and Duel.IsExistingMatchingCard(c100069.filter,tp,LOCATION_REMOVED,0,2,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100069.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()~=2 then return end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c100069.disop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetTarget(c100069.tg)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetTarget(c100069.tg)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetValue(1)
    Duel.RegisterEffect(e2,tp)
end
function c100069.tg(e,c)
    return c:IsSetCard(0xf70)
end