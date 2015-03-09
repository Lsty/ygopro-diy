--虹纹骑士长·黑统
function c999999788.initial_effect(c)
	c:EnableReviveLimit()
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c999999788.spcon)
	e1:SetOperation(c999999788.spop)
	c:RegisterEffect(e1)
	--①
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(85103922,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c999999788.descost)
	e2:SetTarget(c999999788.destg)
	e2:SetOperation(c999999788.desop)
	c:RegisterEffect(e2)
	--②
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c999999788.drstg)
    e3:SetValue(c999999788.drval)
	c:RegisterEffect(e3)
end
function c999999788.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999999788.spfilter,tp,LOCATION_REMOVED,0,3,nil)
end
function c999999788.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c999999788.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c999999788.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999803.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c999999788.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsAbleToDeckAsCost()
end
function c999999788.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf70) and c:IsAbleToDeckAsCost()
end
function c999999788.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,999999788)==0
	and Duel.IsExistingTarget(c999999788.desfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c999999788.desfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()~=2 then return end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.RegisterFlagEffect(tp,999999788,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c999999788.filter(c)
	return c:IsDestructable()
end
function c999999788.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999788.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c999999788.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c999999788.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c999999788.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(c999999788.splimit)
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
function c999999788.splimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0xf70)
end
function c999999788.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xf70)
end
function c999999788.drstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c999999788.repfilter,1,nil,tp) end
	if Duel.IsExistingMatchingCard(c999999788.desfilter,tp,LOCATION_REMOVED,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(100069,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,c999999788.desfilter,tp,LOCATION_REMOVED,0,2,2,nil)
		local g=eg:Filter(c999999788.repfilter,nil,tp)
        if g:GetCount()==1 then
            e:SetLabelObject(g:GetFirst())
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
            local cg=g:Select(tp,1,1,nil)
            e:SetLabelObject(cg:GetFirst())
        end
		Duel.SendtoDeck(tg,nil,2,REASON_COST)
        return true
    else return false end
end
function c999999788.drval(e,c)
    return c==e:GetLabelObject()
end