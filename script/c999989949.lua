--传说之骑士 迪卢木多·奥迪那
function c999989949.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c999989949.synfilter),aux.NonTuner(c999989949.scyfilter2),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999989949.secon)
	e1:SetCost(c999989949.cost)
	e1:SetTarget(c999989949.tg)
	e1:SetOperation(c999989949.op)
	c:RegisterEffect(e1)
	--[[only 1 can exists
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e2:SetCondition(c999989949.excon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e4)--]]
	--pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
	--position
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(11613567,1))
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetHintTiming(0,0x1c0)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c999989949.cost)
	e6:SetTarget(c999989949.postg)
	e6:SetOperation(c999989949.posop)
	c:RegisterEffect(e6)
	--atk/def down
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetDescription(aux.Stringid(999997,4))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetHintTiming(0,0x1c0)
	e7:SetRange(LOCATION_MZONE)
	e7:SetHintTiming(TIMING_DAMAGE_STEP)
	e7:SetCost(c999989949.cost)
	e7:SetTarget(c999989949.dwtg)
	e7:SetOperation(c999989949.dwop)
	c:RegisterEffect(e7)
end
function c999989949.synfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999989949.secon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999989949.scyfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end
function c999989949.filter(c)
	local code=c:GetCode()
	return (code==999999973) 
end
function c999989949.filter2(c)
	local code=c:GetCode()
	return (code==999999974) 
end
function c999989949.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,999989949)<3  end
	Duel.RegisterFlagEffect(tp,999989949,RESET_PHASE+PHASE_END,0,1)
end
function c999989949.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989949.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and
	Duel.IsExistingMatchingCard(c999989949.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999989949.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c999989949.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc1=g1:GetFirst()
	if tc1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc1:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(999997,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc1,c)
		else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc1)
		end
end
    local g2=Duel.SelectMatchingCard(tp,c999989949.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc2=g2:GetFirst()
	if tc2 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc2:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(999997,5))) then
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
--[[function c999989949.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x997)
end
function c999989949.excon(e)
	return Duel.IsExistingMatchingCard(c999989949.exfilter,0,LOCATION_MZONE,0,1,nil)
end--]]
function c999989949.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsLocation(LOCATION_MZONE)  end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c999989949.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
end
end
function c999989949.dwtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,1000)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,g,1,0,1000)
end
function c999989949.dwop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		tc:RegisterEffect(e2)
end
end
