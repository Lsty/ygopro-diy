--VOCALOID-闇音アク
function c79900013.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x799),9,2)
	c:EnableReviveLimit()
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c79900013.sdcon)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c79900013.reptg)
	c:RegisterEffect(e2)
	--cannot attack announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c79900013.antarget)
	c:RegisterEffect(e3)
end
function c79900013.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())>2000
end
function c79900013.defilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c79900013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp~=tp and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(79900013,0)) then
		local g=e:GetHandler():GetOverlayGroup()
		Duel.SendtoGrave(g,REASON_EFFECT)
		local g1=Duel.GetMatchingGroup(c79900013.defilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g1,REASON_EFFECT)
		Duel.SetLP(tp,Duel.GetLP(tp)/2)
		return true
	else return false end
end
function c79900013.antarget(e,c)
	return c~=e:GetHandler()
end