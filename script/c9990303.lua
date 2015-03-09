--龙骑士 艾佛列
function c9990303.initial_effect(c)
	--Synchro
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	c:EnableReviveLimit()
	--Fuck Pos & Effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetCondition(c9990303.condition1)
	e1:SetTarget(c9990303.target1)
	e1:SetOperation(c9990303.operation1)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c9990303.condition2)
	e3:SetTarget(c9990303.target2)
	e3:SetOperation(c9990303.operation2)
	c:RegisterEffect(e3)
end
function c9990303.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9990303.filter(c)
	return not (c:IsPosition(POS_FACEUP_DEFENCE) and (c:IsDisabled() or not (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)))
end
function c9990303.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9990303.filter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c9990303.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9990303.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if not g:GetFirst():IsDefencePos() then Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0) end
	if not g:GetFirst():IsDisabled() then Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0) end
end
function c9990303.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not tc:IsPosition(POS_FACEUP_DEFENCE) then Duel.ChangePosition(tc,POS_FACEUP_DEFENCE) end
		if not tc:IsPosition(POS_FACEUP) then return end
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end
function c9990303.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c9990303.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9990303.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
