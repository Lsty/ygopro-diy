--Black★Cross
function c20121154.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20121154.target)
	e1:SetOperation(c20121154.operation)
	c:RegisterEffect(e1)
end
function c20121154.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c20121154.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20121154.filter,tp,LOCATION_MZONE,0,1,nil) end
	local opt=Duel.SelectOption(tp,aux.Stringid(20121154,0),aux.Stringid(20121154,1))
	e:SetLabel(opt)
end
function c20121154.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20121154.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c20121154.efilter)
		if e:GetLabel()==0 then
			e1:SetLabel(TYPE_TRAP)
		else e1:SetLabel(TYPE_EFFECT) end
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c20121154.efilter(e,te)
	return te:IsActiveType(e:GetLabel())
end