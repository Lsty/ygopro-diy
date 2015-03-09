--传说之骑士 阿斯托尔福
function c999988995.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29981921,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c999988995.descon)
	e1:SetCost(c999988995.descost)
	e1:SetTarget(c999988995.destg)
	e1:SetOperation(c999988995.desop)
	c:RegisterEffect(e1)
	--change pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11613567,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetCountLimit(1)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c999988995.chtg)
	e2:SetOperation(c999988995.chop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c999988995.secon)
	e3:SetTarget(c999988995.tg)
	e3:SetOperation(c999988995.op)
	c:RegisterEffect(e3)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c999988995.disop)
	c:RegisterEffect(e6)
end
function c999988995.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c999988995.cfilter(c,tc)
   return  c:IsType(tc)  and not c:IsPublic()
end
function c999988995.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=bit.band(re:GetActiveType(),0x7)
    if chk==0 then return Duel.IsExistingMatchingCard(c999988995.cfilter,tp,LOCATION_HAND,0,1,nil,tc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c999988995.cfilter,tp,LOCATION_HAND,0,1,1,nil,tc)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c999988995.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c999988995.cfilter2(c)
    return  not c:IsPublic()
end
function c999988995.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
	if Duel.IsExistingMatchingCard(c999988995.cfilter2,tp,LOCATION_HAND,0,1,nil) and
	Duel.SelectYesNo(1-tp,aux.Stringid(999997,14)) then
	Duel.BreakEffect()
    local g=Duel.GetMatchingGroup(c999988995.cfilter2,tp,LOCATION_HAND,0,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
end
end
function c999988995.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc==nil then return end
	if chk==0 then return c  and tc:IsFaceup() and tc:IsPosition(POS_FACEUP_ATTACK)   end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c999988995.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle()  then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,0,0,0)
end
end
function c999988995.secon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999988995.filter(c)
	local code=c:GetCode()
	return (code==999988999) 
end
function c999988995.filter2(c)
	local code=c:GetCode()
	return (code==999989925) 
end
function c999988995.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999988995.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and
	Duel.IsExistingMatchingCard(c999988995.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999988995.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local  g1=Duel.SelectMatchingCard(tp,c999988995.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c999988995.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1  then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc1:IsAbleToHand()  or Duel.SelectYesNo(tp,aux.Stringid(999997,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc1,c)
		else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc1)
			
		end
end
    if tc2  then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc2:IsAbleToHand()  or Duel.SelectYesNo(tp,aux.Stringid(999997,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc2,c)
		else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc2)
			
		end
end
end
function c999988995.disop(e,tp,eg,ep,ev,re,r,rp)
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