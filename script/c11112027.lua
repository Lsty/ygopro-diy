--龙魂觉醒
function c11112027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1,11112027+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11112027.condition)
	e1:SetOperation(c11112027.activate)
	c:RegisterEffect(e1)
end
function c11112027.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not at or tc:IsFacedown() or at:IsFacedown() then return false end
	if tc:IsControler(1-tp) then tc=at end
	e:SetLabelObject(tc)
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and tc:IsSetCard(0x15b)
end
function c11112027.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e2:SetValue(tc:GetBaseDefence()*2)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_DAMAGE_STEP_END)
		e3:SetCountLimit(1)
		e3:SetOperation(c11112027.tdop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e3)
	end
end
function c11112027.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
		or Duel.SelectOption(tp,aux.Stringid(11112027,0),aux.Stringid(11112027,1))==0 then
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	else
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end