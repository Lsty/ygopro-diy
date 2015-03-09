--传说之狂战士 斯巴达克斯
function c999989940.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c999989940.synfilter),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999989940.secon)
	e1:SetTarget(c999989940.setg)
	e1:SetOperation(c999989940.seop)
	c:RegisterEffect(e1)
    --must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_EP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c999989940.becon)
	c:RegisterEffect(e3)
	--ind
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(c999989940.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	--[[atk u/d
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLE_START)
	e6:SetTarget(c999989940.attg)
	e6:SetOperation(c999989940.atop)
	c:RegisterEffect(e6)--]]
   --[[ --counter permit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_DAMAGE_STEP_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c999989940.cpop)
	c:RegisterEffect(e7)--]]
    --negate
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetCountLimit(1)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c999989940.discon)
	e8:SetCost(c999989940.discost)
	e8:SetTarget(c999989940.distg)
	e8:SetOperation(c999989940.disop)
	c:RegisterEffect(e8)
	--only 1 can exists
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e9:SetCondition(c999989940.excon)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e11)
	end
function c999989940.synfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999989940.secon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999989940.filter(c)
	local code=c:GetCode()
	return (code==999989948) 
end
function c999989940.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989940.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999989940.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999989940.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup()
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
function c999989940.becon(e)
	return e:GetHandler():IsAttackable()
end
function c999989940.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
--[[function c999989940.attg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc==nil then return end
	if chk==0 then return c  and tc:IsFaceup()   end
end
function c999989940.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle()  then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
end
function c999989940.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToBattle()   then
	 c:AddCounter(0x1112,1)
end
end--]]
function c999989940.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainNegatable(ev)
end
function c999989940.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1112,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1112,2,REASON_COST)
end
function c999989940.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c999989940.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c999989940.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9984) and c:IsType(TYPE_SYNCHRO)
end
function c999989940.excon(e)
	return Duel.IsExistingMatchingCard(c999989940.exfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end