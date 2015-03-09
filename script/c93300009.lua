--超我 古明地恋
function c93300009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),5,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP+0x1c0)
	e1:SetCondition(c93300009.negcon)
	e1:SetCost(c93300009.negcost)
	e1:SetTarget(c93300009.negtg)
	e1:SetOperation(c93300009.negop)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	if Duel.IsExistingMatchingCard(c93300009.filter1,tp,0,LOCATION_MZONE,1,nil) then
		e2:SetTargetRange(0,LOCATION_SZONE)
	elseif Duel.IsExistingMatchingCard(c93300009.filter1,tp,LOCATION_MZONE,0,1,nil) then
		e2:SetTargetRange(LOCATION_SZONE,0)
	elseif Duel.IsExistingMatchingCard(c93300009.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c93300009.filter1,tp,0,LOCATION_MZONE,1,nil) then
		e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	end
	e2:SetTarget(c93300009.acttg)
	e2:SetCondition(c93300009.dscon)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c93300009.sumsuc)
	c:RegisterEffect(e3)
end
function c93300009.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c93300009.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c93300009.filter2(c)
	return c:IsFaceup() and (c:GetAttack()~=0 or c:GetDefence()~=0)
end
function c93300009.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93300009.filter2,tp,0,LOCATION_MZONE,1,nil) end
end
function c93300009.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	g=Duel.GetMatchingGroup(c93300009.filter2,tp,0,LOCATION_MZONE,nil)
	tc=g:GetFirst()
	while tc do
		if tc:GetAttack()~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		if tc:GetDefence()~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENCE_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c93300009.filter1(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function c93300009.acttg(e,c)
	return c:IsFacedown() and c:GetSequence()~=5
end
function c93300009.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c93300009.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end