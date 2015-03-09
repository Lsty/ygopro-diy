--传说之魔术师 吉尔斯·德·莱斯
function c999999996.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c999999996.xyzfilter),3,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999999996.con)
	e1:SetTarget(c999999996.tg)
	e1:SetOperation(c999999996.op)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c999999996.spcost)
	e2:SetTarget(c999999996.sptg)
	e2:SetOperation(c999999996.spop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(c999999996.tgcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(c999999996.effval)
	c:RegisterEffect(e4)
    --hands
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999999,3))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,999999996+EFFECT_COUNT_CODE_OATH)
	e5:SetCondition(c999999996.hcon)
	e5:SetTarget(c999999996.htg)
	e5:SetOperation(c999999996.hop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(c999999996.desop)
	c:RegisterEffect(e6)
end
function c999999996.filter(c)
	local code=c:GetCode()
	return (code==999999975)  
end
function c999999996.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
end
function c999999996.con(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c999999996.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999996.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999996.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999996.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(999997,5))) then
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
function c999999996.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c999999996.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999989941,0,0x4011,2000,2000,4,RACE_FIEND,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c999999996.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,999989941,0,0x4011,2000,2000,4,RACE_FIEND,ATTRIBUTE_WATER) then
		for i=1,2 do
		local token=Duel.CreateToken(tp,999989941)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		token:RegisterEffect(e1,true)
		--[[if e:GetHandler():IsHasEffect(999999975) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e2,true)
	    local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENCE)
		token:RegisterEffect(e3,true)--]]
end
	Duel.SpecialSummonComplete()
	end
end
function c999999996.ifilter(c)
	return  c:IsCode(999989941)
end
function c999999996.tgcon(e)
	return Duel.IsExistingMatchingCard(c999999996.ifilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c999999996.effval(e,te,tp)
	return tp~=e:GetHandlerPlayer()
end
function c999999996.atkfilter(c)
	return c:IsCode(999989941)
end
function c999999996.hcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c999999996.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) or Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	local op=0
	if Duel.IsPlayerCanDraw(tp,1) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 then
		op=Duel.SelectOption(tp,aux.Stringid(999999,4),aux.Stringid(999999,5))
	elseif Duel.IsPlayerCanDraw(tp,1) then
		Duel.SelectOption(tp,aux.Stringid(999999,4))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(999999,5))
		op=1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.SetTargetPlayer(tp)
	    Duel.SetTargetParam(1)
	   	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
end
function c999999996.hop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	    Duel.Draw(p,d,REASON_EFFECT)
	else
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0,nil)
	    if g:GetCount()==0 then return end
	    local sg=g:RandomSelect(1-tp,1)
	    Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)	
end
end	
function c999999996.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,999999941) then
		local dg=Duel.GetMatchingGroup(Card.IsCode,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,999999941)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
	