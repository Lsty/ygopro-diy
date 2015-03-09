--謙信醬
function c18730303.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),5,2,c18730303.ovfilter,aux.Stringid(38495396,1),2,c18730303.xyzop)
	c:EnableReviveLimit()
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1639384,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,18730303)
	e3:SetCost(c18730303.cost)
	e3:SetOperation(c18730303.operation)
	c:RegisterEffect(e3)
	--chain attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72989439,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCountLimit(1,18730303)
	e4:SetCondition(c18730303.atcon)
	e4:SetOperation(c18730303.atop)
	c:RegisterEffect(e4)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetCondition(c18730303.limcon)
	c:RegisterEffect(e1)
	if not c18730303.global_check then
		c18730303.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c18730303.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c18730303.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsCode(18730303) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,18730303,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,18730303,RESET_PHASE+PHASE_END,0,1) end
end
function c18730303.limcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),18730303)~=0
end
function c18730303.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabb)  and c:GetRank()==4
end
function c18730303.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(187303030,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c18730303.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetFlagEffect(187303030)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18730303.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c18730303.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable()
end
function c18730303.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
