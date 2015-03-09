--时符·膨胀空间
function c98700020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c98700020.condition)
	e1:SetCost(c98700020.cost)
	e1:SetTarget(c98700020.target)
	e1:SetOperation(c98700020.activate)
	c:RegisterEffect(e1)
	if c98700020.counter==nil then
		c98700020.counter=true
		c98700020[0]=0
		c98700020[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c98700020.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(c98700020.addcount)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_CHAIN_NEGATED)
		e4:SetOperation(c98700020.addcount1)
		Duel.RegisterEffect(e4,0)
	end
end
function c98700020.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c98700020[0]=0
	c98700020[1]=0
end
function c98700020.addcount(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x986) and re:GetHandler():GetCode()~=98700020 then
		c98700020[tp]=c98700020[tp]+1
	end
end
function c98700020.addcount1(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x986) then
		if c98700020[tp]==0 then c98700020[tp]=1 end
		c98700020[tp]=c98700020[tp]-1
	end
end
function c98700020.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DAMAGE and Duel.IsDamageCalculated() then return false end
	return true
end
function c98700020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98700020)==0 end
	Duel.RegisterFlagEffect(tp,98700020,RESET_PHASE+PHASE_END,0,1)
end
function c98700020.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x987)
end
function c98700020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98700020.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c98700020.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98700020.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(300+c98700020[tp]*500)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
	end
end