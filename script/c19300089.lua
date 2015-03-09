--镜现诗·不自然的冷气
function c19300089.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c19300089.tfilter,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c19300089.descon)
	e1:SetOperation(c19300089.operation)
	c:RegisterEffect(e1)
end
function c19300089.tfilter(c)
	return c:IsSetCard(0x193)
end
function c19300089.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c19300089.cfilter(c)
	return c:IsSetCard(0x193) and c:IsType(TYPE_MONSTER)
end
function c19300089.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c19300089.cfilter,tp,LOCATION_GRAVE,0,nil)
	if ct>=2 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c19300089.atkval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
	if ct>=5 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c19300089.efilter)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
	if ct==9 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c19300089.atkval(e,c)
	return Duel.GetMatchingGroupCount(c19300089.cfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*300
end
function c19300089.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
	if te:IsActiveType(TYPE_MONSTER) and te:IsHasType(0x7e0) then
		local atk=e:GetHandler():GetAttack()
		local ec=te:GetHandler()
		return ec:GetAttack()<atk
	end
	return false
end