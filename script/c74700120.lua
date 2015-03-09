--义妹·奎利亚
function c74700120.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74700120,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,74700120)
	e2:SetCondition(c74700120.descon)
	e2:SetTarget(c74700120.destg)
	e2:SetOperation(c74700120.desop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c74700120.splimit)
	c:RegisterEffect(e3)
end
function c74700120.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_NORMAL) and not c:IsSetCard(0x747) and c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end
function c74700120.cfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_NORMAL) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c74700120.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c74700120.cfilter,1,nil,tp)
end
function c74700120.desfilter(c)
	return c:IsSetCard(0x747) and c:IsType(TYPE_SPELL) and c:IsFaceup() and c:IsDestructable()
end
function c74700120.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74700120.desfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c74700120.desfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c74700120.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c74700120.desfilter,tp,LOCATION_SZONE,0,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 and Duel.IsPlayerCanDraw(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(74700120,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end