--阿利姆斯之墙
function c11111046.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11111046.target)
	e1:SetOperation(c11111046.operation)
	c:RegisterEffect(e1)
end
function c11111046.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_FAIRY+RACE_SPELLCASTER)
end
function c11111046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111046.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c11111046.cfilter(c)
	return c:IsFaceup() and (c:IsCode(11111000) or c:IsCode(11111002) or c:IsCode(11111008)) and c:GetOverlayCount()~=0
end
function c11111046.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11111046.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetValue(c11111046.efilter)
		tc:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(c11111046.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		   tc:RegisterFlagEffect(11111046,RESET_EVENT+0x1fc0000+RESET_PHASE+RESET_END,0,1)
	       local e2=Effect.CreateEffect(e:GetHandler())
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
		   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e2:SetValue(c11111046.infilter)
		   e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		   tc:RegisterEffect(e2)
		   local e3=Effect.CreateEffect(e:GetHandler())
		   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		   e3:SetCode(EVENT_CHAIN_SOLVING)
		   e3:SetCondition(c11111046.discon)
		   e3:SetOperation(c11111046.disop)
		   e3:SetReset(RESET_PHASE+RESET_END)
		   e3:SetLabelObject(tc)
		   Duel.RegisterEffect(e3,tp)
		end   
		tc=g:GetNext()
	end
end
function c11111046.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c11111046.infilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
function c11111046.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(11111046)==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(tc) and re:IsActiveType(TYPE_MONSTER)
end
function c11111046.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end