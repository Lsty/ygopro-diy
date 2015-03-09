--奔放不羁的鬼 伊吹萃香
function c41700014.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),4,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c41700014.atkcon)
	e1:SetCost(c41700014.atkcost)
	e1:SetTarget(c41700014.target)
	e1:SetOperation(c41700014.atkop)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c41700014.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return e:GetHandler():GetBattleTarget()~=nil and phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()
end
function c41700014.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetFlagEffect(41700014)==0
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(41700014,RESET_PHASE+RESET_DAMAGE_CAL,0,1)
end
function c41700014.filter(c)
	return (c:IsSetCard(0x417) or (c:IsRace(RACE_FIEND) and c:IsType(TYPE_NORMAL))) and c:IsAbleToRemove()
end
function c41700014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c41700014.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c41700014.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c41700014.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c41700014.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then	return end
		local ba=tc:GetAttack()
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetOwnerPlayer(tp)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_DAMAGE_CAL)
		e1:SetValue(ba)
		if a:GetControler()==tp then
			a:RegisterEffect(e1)
		else
			d:RegisterEffect(e1)
		end
	end
end