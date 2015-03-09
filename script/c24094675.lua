--安吉莉亚的下午茶
function c24094675.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c24094675.condition)
	e1:SetOperation(c24094675.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c24094675.handcon)
	c:RegisterEffect(e2)
end
function c24094675.cfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c24094675.handcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return not g:IsExists(c24094675.cfilter,1,nil)
end
function c24094675.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c24094675.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end