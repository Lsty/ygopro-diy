--传说之魔术师　威廉·莎士比亚
function c999988994.initial_effect(c)
	--synchro summon
	c:SetUniqueOnField(1,0,999988994)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c999988994.synfilter),aux.NonTuner(c999988994.scyfilter2),1)
	c:EnableReviveLimit()
	local g=Group.CreateGroup()
	g:KeepAlive()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(c999988994.eqcheck)
	c:RegisterEffect(e1)
	e1:SetLabelObject(g)
	--buff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999997,12))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c999988994.cost)
	e2:SetTarget(c999988994.target)
	e2:SetOperation(c999988994.operation)
	c:RegisterEffect(e2)
	e2:SetLabelObject(g)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c999988994.secon)
	e3:SetTarget(c999988994.tg)
	e3:SetOperation(c999988994.op)
	c:RegisterEffect(e3)
end
function c999988994.synfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999988994.scyfilter2(c)
	return  c:IsRace(RACE_SPELLCASTER)
end
function c999988994.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:GetLabelObject():Merge(g)
end
function c999988994.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()  end
	  local c=e:GetHandler()
		local g=c:GetEquipGroup()
		local sg=Group.CreateGroup()
		sg:Merge(g)
		sg:AddCard(c)
	   if Duel.Remove(sg,nil,REASON_COST+REASON_TEMPORARY)>0 then
		local e1=Effect.CreateEffect(c)
	     e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(e)
		e1:SetCountLimit(1)
		e1:SetCondition(c999988994.retcon)
		e1:SetOperation(c999988994.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c999988994.retcon(e,tp,eg,ep,ev,re,r,rp)
 return not e:GetHandler():IsDisabled()
 end
function c999988994.retop(e,tp,eg,ep,ev,re,r,rp)
     if Duel.GetFlagEffect(tp,999988994)==0 then return end 
	if Duel.ReturnToField(e:GetHandler())    then
    local ft1=Duel.GetLocationCount(tp,LOCATION_SZONE)  
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local g=e:GetLabelObject():GetLabelObject()
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
function c999988994.bufilter(c)
	return  (c:IsType(TYPE_EQUIP) or c:IsType(TYPE_MONSTER)) and c:IsFaceup()
end
function c999988994.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject()
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c999988994.bufilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999988994.bufilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and
    Duel.IsExistingTarget(c999988994.bufilter,tp,LOCATION_SZONE,0,1,g:GetFirst())  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c999988994.bufilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c999988994.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c999988994.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.RegisterFlagEffect(tp,999988994,RESET_PHASE+PHASE_END,0,2)
end
function c999988994.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c999988994.secon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999988994.filter(c)
	local code=c:GetCode()
	return (code==999988993) 
end
function c999988994.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999988994.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999988994.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local  g=Duel.SelectMatchingCard(tp,c999988994.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc  then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand()  or Duel.SelectYesNo(tp,aux.Stringid(999997,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc,c)
		else
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			
		end
end
end