--镜现诗·死欲的半灵
function c19300040.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x193),4,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c19300040.atkcon)
	e1:SetCost(c19300040.atkcost)
	e1:SetOperation(c19300040.atkop)
	c:RegisterEffect(e1)
end
function c19300040.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return e:GetHandler():GetBattleTarget()~=nil and phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()
end
function c19300040.cffilter(c)
	return c:IsSetCard(0x193) and not c:IsPublic()
end
function c19300040.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetFlagEffect(19300040)==0
		and Duel.IsExistingMatchingCard(c19300040.cffilter,tp,LOCATION_HAND,0,1,nil) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19300040.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:GetHandler():RegisterFlagEffect(19300040,RESET_PHASE+RESET_DAMAGE_CAL,0,1)
end
function c19300040.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetBattleTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_DEFENCE_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
end