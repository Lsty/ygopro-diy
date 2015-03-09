--战场女武神 塞露贝利亚 瓦尔基里
function c11113004.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113004,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11113004)
	e2:SetCondition(c11113004.negcon)
	e2:SetCost(c11113004.negcost)
	e2:SetTarget(c11113004.negtg)
	e2:SetOperation(c11113004.negop)
	c:RegisterEffect(e2)
	--send to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11113004,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,111130040)
	e3:SetCondition(c11113004.tdcon)
	e3:SetCost(c11113004.tdcost)
	e3:SetTarget(c11113004.tdtg)
	e3:SetOperation(c11113004.tdop)
	c:RegisterEffect(e3)
end
function c11113004.mat_filter(c)
	return c:GetLevel()~=8
end	
function c11113004.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainNegatable(ev)
end
function c11113004.dfilter(c)
    return c:IsSetCard(0x15c) and c:IsAbleToDeckAsCost()
end	
function c11113004.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113004.dfilter,tp,LOCATION_REMOVED,0,1,nil)
        and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c11113004.dfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST+REASON_TEMPORARY)
end
function c11113004.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsOnField() then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
end
function c11113004.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsOnField() then
	    ec:CancelToGrave()
	    Duel.SendtoHand(ec,nil,REASON_EFFECT)
	end	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+RESET_END)
	e1:SetLabelObject(c)
	e1:SetCountLimit(1)
	e1:SetOperation(c11113004.retop)
	Duel.RegisterEffect(e1,tp)
end
function c11113004.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c11113004.cfilter(c)
    return c:IsSetCard(0x15c) and bit.band(c:GetType(),0x82)==0x82
end	
function c11113004.mfilter(c)
    return c:IsPosition(POS_FACEUP_ATTACK)
end		
function c11113004.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.IsExistingMatchingCard(c11113004.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	    and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2
end
function c11113004.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11113004.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c11113004.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end