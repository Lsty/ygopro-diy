--少女的先决
function c30303018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c30303018.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c30303018.handcon)
	c:RegisterEffect(e2)
end
function c30303018.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetOperation(c30303018.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c30303018.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if  ep~=tp and rc:IsType(TYPE_SPELL+TYPE_TRAP) and loc~=LOCATION_SZONE
		and re:GetHandler():GetCode()~=30303018 then
		Duel.NegateEffect(ev)
		if re:GetHandler():IsRelateToEffect(re) then
		Duel.BreakEffect()
		Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	    end
	end
end
function c30303018.handcon(e,tp,eg,ep,ev,re,r,rp)
	return 	Duel.IsExistingMatchingCard(c30303018.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c30303018.filter(c,e,tp)
	return c:IsSetCard(0xabb) and c:IsFaceup()
end