--传说之王 英雄王 吉尔伽美什
function c999999997.initial_effect(c)
	c:SetUniqueOnField(1,0,999999997)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c999999997.xyzfilter),8,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c999999997.tg)
	e1:SetOperation(c999999997.op)
	c:RegisterEffect(e1)
    --return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29343734,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c999999997.retcon)
	e2:SetTarget(c999999997.rettg)
	e2:SetOperation(c999999997.retop)
	c:RegisterEffect(e2)
    --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999998,5))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c999999997.descost)
	e3:SetTarget(c999999997.destg)
	e3:SetOperation(c999999997.desop)
	c:RegisterEffect(e3)
    --cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
end
function c999999997.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsSetCard(0x984) or c:IsSetCard(0x985))
end
function c999999997.filter(c)
	local code=c:GetCode()
	return (code==999999963) 
end
function c999999997.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999997.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
	and  Duel.GetLocationCount(tp,LOCATION_SZONE)>0  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectTarget(tp,c999999997.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    Duel.SetChainLimit(c999999997.chlimit)
end
function c999999997.filter2(c) 
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()  and  c:GetCode()~=999999963
end
function c999999997.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFirstTarget()
	 if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if g1:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Equip(tp,g1,c)
	end
	if Duel.IsExistingMatchingCard(c999999997.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(999999,2))  then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c999999997.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g2  then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
end
function c999999997.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c999999997.retfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToDeck() 
end
function c999999997.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999997.retfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c999999997.retfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetChainLimit(c999999997.chlimit)
end
function c999999997.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999999997.retfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
end
function c999999997.sgfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost() 
end
function c999999997.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and  Duel.IsExistingMatchingCard(c999999997.sgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and 
	e:GetHandler():GetAttackAnnouncedCount()==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct1=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local rg=Duel.SelectMatchingCard(tp,c999999997.sgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,ct1,nil)
	Duel.SendtoGrave(rg,REASON_EFFECT)
	e:SetLabel(rg:GetCount())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c999999997.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local tc=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc,tc,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,tc,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,tc*500,0,1-tp,nil)
    Duel.SetChainLimit(c999999997.chlimit)
end
function c999999997.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
function c999999997.chlimit(e,ep,tp)
	return tp==ep
end









