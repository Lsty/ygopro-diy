--女仆长 十六夜咲夜
function c999989006.initial_effect(c)
	c:SetUniqueOnField(1,0,999989006)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c999989006.xyz),4,2)
	c:EnableReviveLimit()
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11613567,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c999989006.postg)
	e1:SetOperation(c999989006.posop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14152862,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c999989006.discon)
	e2:SetCost(c999989006.discost)
	e2:SetTarget(c999989006.distg)
	e2:SetOperation(c999989006.disop)
	c:RegisterEffect(e2)
end
function c999989006.xyz(c)
	return (c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb))
end
function c999989006.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsLocation(LOCATION_MZONE)  end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c999989006.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
end
end
function c999989006.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c999989006.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb)) and c:IsAbleToDeckAsCost()
end
function c999989006.hfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c999989006.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	and Duel.IsExistingMatchingCard(c999989006.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
	and Duel.IsExistingMatchingCard(c999989006.hfilter,tp,LOCATION_HAND,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c999989006.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	local g2=Duel.SelectTarget(tp,c999989006.hfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g3=Group.CreateGroup()
    g3:Merge(g1)
	g3:Merge(g2)
	if g3:GetCount()~=2 then return end
	Duel.SendtoDeck(g3,nil,2,REASON_COST)
end
function c999989006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c999989006.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		   re:GetHandler():CancelToGrave() 
		Duel.SendtoDeck(re:GetHandler(),nil,2,REASON_EFFECT)
end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(0,1)
			    e1:SetValue(c999989006.aclimit)
	            e1:SetLabel(re:GetHandler():GetCode())
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END+RESET_SELF_TURN,2)
				Duel.RegisterEffect(e1,tp)
end
function c999989006.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end