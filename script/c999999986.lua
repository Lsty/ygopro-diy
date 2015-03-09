--传说之骑士 库丘林
function c999999986.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c999999986.synfilter),aux.NonTuner(c999999986.scyfilter2),1)
	c:EnableReviveLimit()
	local g=Group.CreateGroup()
	g:KeepAlive()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(c999999986.eqcheck)
	c:RegisterEffect(e1)
	e1:SetLabelObject(g)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(999998,15))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c999999986.cost)
	e2:SetTarget(c999999986.target)
	e2:SetOperation(c999999986.operation)
	c:RegisterEffect(e2)
	e2:SetLabelObject(g)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c999999986.secon)
	e3:SetTarget(c999999986.tg)
	e3:SetOperation(c999999986.op)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--[[only 1 can exists
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e5:SetCondition(c999999986.excon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e7)--]]
end
function c999999986.synfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999999986.scyfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end
function c999999986.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:GetLabelObject():Merge(g)
end
function c999999986.sgfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c999999986.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999986.sgfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c999999986.sgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c999999986.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c999999986.operation(e,tp,eg,ep,ev,re,r,rp)
	    local c=e:GetHandler()
		local g=c:GetEquipGroup()
		local sg=Group.CreateGroup()
		sg:Merge(g)
		sg:AddCard(c)
		if Duel.Remove(sg,nil,REASON_EFFECT+REASON_TEMPORARY)>0  then
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			Duel.RegisterFlagEffect(tp,999999986,RESET_PHASE+PHASE_END,0,1)
			e1:SetCondition(c999999986.retcon)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetLabelObject(e)
		e1:SetCountLimit(1)
		e1:SetOperation(c999999986.retop)
		Duel.RegisterEffect(e1,tp)
    end
end
function c999999986.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,999999986)==0
end
function c999999986.retop(e,tp,eg,ep,ev,re,r,rp)
   local g=e:GetLabelObject():GetLabelObject()
   if e:GetHandler():IsForbidden() or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  then 
	Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	Duel.SendtoGrave(g,REASON_RULE)
	end
    if Duel.ReturnToField(e:GetHandler()) then
    local ft1=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local tc=g:GetFirst()
	while tc do
	if tc:GetControler()==tp and ft1>0 then
	Duel.Equip(tp,tc,e:GetHandler(),true,true)
	else if tc:GetControler()==1-tp and ft2>0 then
	Duel.Equip(1-tp,tc,e:GetHandler(),true,true)
	end
	end
	tc=g:GetNext()	
	end
	Duel.EquipComplete()
    e:GetLabelObject():GetLabelObject():Clear()
	end
end
function c999999986.secon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999999986.filter(c)
	local code=c:GetCode()
	return (code==999999967) 
end
function c999999986.filter2(c)
	local code=c:GetCode()
	return (code==999999993) 
end
function c999999986.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999986.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and
	Duel.IsExistingMatchingCard(c999999986.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999986.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local  g1=Duel.SelectMatchingCard(tp,c999999986.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c999999986.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1  then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup()
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
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup()
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
--[[function c999999986.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x997)
end
function c999999986.excon(e)
	return Duel.IsExistingMatchingCard(c999999986.exfilter,0,LOCATION_MZONE,0,1,nil)
end--]]