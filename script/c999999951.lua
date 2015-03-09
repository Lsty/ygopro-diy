--Saber Alternative
function c999999951.initial_effect(c)
    c:SetUniqueOnField(1,0,999999951)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c999999951.ovfilter,aux.Stringid(999998,12))
	c:EnableReviveLimit()
	--search
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c999999951.scon)
	e0:SetTarget(c999999951.stg)
	e0:SetOperation(c999999951.sop)
	c:RegisterEffect(e0)
	--atk/def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c999999951.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e2)
	 --咖喱棒!
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999998,5))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c999999951.excon)
	e3:SetCost(c999999951.excost)
	e3:SetTarget(c999999951.extg)
	e3:SetOperation(c999999951.exop)
	c:RegisterEffect(e3)
	 --disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c999999951.disop)
	c:RegisterEffect(e6)
	--补魔
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(39030163,1))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetCountLimit(1)
	e7:SetCondition(c999999951.mgcon)
	e7:SetOperation(c999999951.mgop)
	c:RegisterEffect(e7)
end
function c999999951.ovfilter(c)
	return c:IsFaceup()  and c:IsSetCard(0x991)
end
function c999999951.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c999999951.eqfilter(c)
	return c:IsCode(999999981) 
end
function c999999951.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return   chkc:IsLocation(LOCATION_GRAVE+LOCATION_DECK) and chkc:IsControler(tp) and c999999951.eqfilter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and 
	Duel.IsExistingMatchingCard(c999999951.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e:GetHandler()) 
	 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectTarget(tp,c999999951.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999951.sfilter(c)
	return c:IsCode(999999984) and c:IsAbleToHand()
end
function c999999951.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFirstTarget()
	 if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if g1:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Equip(tp,g1,c)
	end
	if  Duel.IsExistingMatchingCard(c999999951.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and
	Duel.SelectYesNo(tp,aux.Stringid(999999,2))  then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c999999951.sfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g2   then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
end
function c999999951.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c999999951.excon(e)
    local eg=e:GetHandler():GetEquipGroup()
	 return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x991) and eg and eg:IsExists(Card.IsCode,1,nil,999999981) 
end
function c999999951.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST)  end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c999999951.exfilter(c)
	return c:IsCode(999999984) and c:IsAbleToGrave()
end
function c999999951.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c999999951.exfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectTarget(tp,c999999951.exfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c999999951.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	Duel.SendtoGrave(g,REASON_EFFECT)
		local ae=g:GetActivateEffect()
			local e1=Effect.CreateEffect(g)
			e1:SetDescription(ae:GetDescription())
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			e1:SetTarget(c999999951.spelltg)
			e1:SetOperation(c999999951.spellop)
			g:RegisterEffect(e1)
end
function c999999951.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c999999951.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function c999999951.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_SPELL) or rp==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then 
		Duel.NegateEffect(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end
function c999999951.mgcon(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	return Duel.GetTurnPlayer()==tp and  g:GetCount()>0
end
function c999999951.mgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,g:GetCount(),nil)
	if not  c:IsRelateToEffect(e)  then return end
	Duel.Overlay(c,tg) 
	if Duel.IsExistingMatchingCard(c999999951.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and
	Duel.SelectYesNo(tp,aux.Stringid(999999,2))  then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c999999951.sfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g2   then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
end
end