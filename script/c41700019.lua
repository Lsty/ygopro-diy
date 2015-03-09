--四天王奥义「三步坏废」
function c41700019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c41700019.cost)
	e1:SetTarget(c41700019.target)
	e1:SetOperation(c41700019.operation)
	c:RegisterEffect(e1)
end
function c41700019.costfilter(c)
	return c:IsRace(RACE_FIEND) and c:GetAttack()>=2000
end
function c41700019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c41700019.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c41700019.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c41700019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c41700019.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e1:SetTarget(c41700019.aclimit)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,4)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,3)
	end
	Duel.RegisterEffect(e1,tp)
	--cannot set
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(aux.TRUE)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e2:SetReset(RESET_PHASE+PHASE_STANDBY,4)
	else
		e2:SetReset(RESET_PHASE+PHASE_STANDBY,3)
	end
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,4)
	else
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,3)
	end
	e3:SetCountLimit(1)
	e3:SetOperation(c41700019.spop2)
	Duel.RegisterEffect(e3,tp)
	e:GetHandler():SetTurnCounter(0)
end
function c41700019.aclimit(e,c)
	return c:IsFacedown()
end
function c41700019.filter(c)
	return c:IsFacedown() and c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c41700019.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		local g=Duel.GetMatchingGroup(c41700019.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end